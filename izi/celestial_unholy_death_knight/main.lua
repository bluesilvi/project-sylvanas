--[[
    Celestial Unholy Death Knight rotation for IZI SDK

    This is the main rotation file containing the actual rotation logic for Unholy Death Knight.
    The rotation is meant to be an example and is not perfect. It supports the hero tree Rider of Apocalypse.

    Features:
    - Single target and AoE rotation logic
    - Cooldown management with configurable TTD validation
    - Defensive spell handling with health forecasting
    - Artifact power integration (Twisted Crusade, Remix Time)
    - Automatic pet summoning and minion tracking
    - Pandemic-aware disease application
    - Priority-based spell casting with resource management

    AoE Talents: CwPAclESCN5uIs3wGGVadXqL3BwMDzYmxwMzMzMTDjZMzMGAAAAAAAAmZmZDzYmBAsNDzY2mZmxYGgFzihhMwsxQjFMAzAYA

    Author: Voltz
]]

--Import our dependencies
local SPELLS = require("spells")
local menu = require("menu")
local izi = require("common/izi_sdk")
local enums = require("common/enums")

--Define our constants
local BUFFS = enums.buff_db
local REMIX_CASTING_MOVE_BUFF_IDS =
{
    1242563,  --Storm Surger
    12343774, --Storm Surger
    1258589   --Brewing storm
}

--Delay for rotation after dismounting
local DISMOUNT_DELAY_MS = 1000

--Value to determine if a CD will be ready soon
local COOLDOWN_READY_SOON_SEC = 7

--Minimum time remaining for cooldowns to consider remix time
local MINIMUM_COOLDOWN_SEC = 30

--Caclulate the pandemic value for VIRULENT_PLAGUE so we can refresh at this value to get longer uptime (TODO: Add for frost fever)
local VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_SEC = 13.5 * 0.30
local VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_MS = VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_SEC * 1000

--We define some local variables that we will update later
--inside of our update handler, this just reduces calls to these methods
--once per game tick instead of every time it is needed in any logic
local ping_ms = 0
local ping_sec = 0
local game_time_ms = 0
local gcd = 0
local runic_power = 0
local runes = 0
local last_movement_time_ms = 0
local last_mounted_time_ms = 0

--Returns the time in milliseconds since the last movement
---@return number time_since_last_movement_ms
local function time_since_last_movement_ms()
    return game_time_ms - last_movement_time_ms
end

--Returns the time in seconds since the last movement
---@return number time_since_last_movement_sec
local function time_since_last_movement_sec()
    return time_since_last_movement_ms() / 1000
end

--Returns the time in milliseconds since the last dismount
---@return number time_since_last_dismount_ms
local function time_since_last_dismount_ms()
    return game_time_ms - last_mounted_time_ms
end

--Returns the time in seconds since the last dismount
---@return number time_since_last_dismount_sec
local function time_since_last_dismount_sec()
    return time_since_last_dismount_ms() / 1000
end

---Returns true if the unit has a minion with the given NPC ID
---@param unit game_object
---@param npc_id number
---@return boolean has_minion
local function unit_has_minion(unit, npc_id)
    local minions = unit:get_all_minions()

    for i = 1, #minions do
        local minion = minions[i]
        if minion:get_npc_id() == npc_id then
            return true
        end
    end

    return false
end

---Checks if the unit has an abomination active
---@param unit game_object
---@return boolean abomination_active
local function unit_has_abomination(unit)
    local abomination_npc_id = 149555
    return unit_has_minion(unit, abomination_npc_id)
end

---Checks if the unit has apocalypse minions active
---@param unit game_object
---@return boolean apocalypse_active
local function unit_has_apocalypse(unit)
    local army_of_the_dead_npc_id = 237409
    return unit_has_minion(unit, army_of_the_dead_npc_id)
end

---Finds an enemy that has trollbane's furry (chains of ice) active
---@param enemies game_object[]
---@return game_object|nil trollbanes_enemy
local function get_trollbanes_enemy(enemies)
    for i = 1, #enemies do
        local enemy = enemies[i]
        if enemy:has_debuff(BUFFS.TROLLBANES_ICE_FURY) then
            return enemy
        end
    end
end

--Finds the first inactive virulent plague or frost fever enemy
---@param enemies game_object[]
---@return game_object|nil inactive_enemy
local function get_inactive_virulent_plague_or_frost_fever_enemy(enemies)
    local has_superstrain = SPELLS.SUPERSTRAIN:is_learned()
    for i = 1, #enemies do
        local enemy = enemies[i]
        if enemy:debuff_remains_sec(BUFFS.VIRULENT_PLAGUE) < VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_SEC or (has_superstrain and enemy:debuff_down(BUFFS.FROST_FEVER)) then
            return enemy
        end
    end
end

--Gets all enemies with virulent plague
---@param enemies game_object[]
---@return game_object[] virulent_plague_enemies
local function get_virulent_plague_enemies(enemies)
    local virulent_plague_enemies = {}

    for i = 1, #enemies do
        local enemy = enemies[i]
        if enemy:has_debuff(BUFFS.VIRULENT_PLAGUE) then
            table.insert(virulent_plague_enemies, enemy)
        end
    end

    return virulent_plague_enemies
end

--Finds the first festering wound enemy
---@param enemies game_object[]
---@return game_object|nil festering_wound_enemy
local function get_first_festering_wound_enemy(enemies)
    for i = 1, #enemies do
        local enemy = enemies[i]
        if enemy:has_debuff(BUFFS.FESTERING_WOUND) then
            return enemy
        end
    end
end

--Checks if the enemy is within soul reaper execute range
---@param enemy game_object
---@return boolean is_in_execute, number health
local function should_soul_reaper(enemy)
    local execute_hp = 35
    local execute_deadline = 5
    local health = enemy:get_health()
    local health_percentage = enemy:get_health_percentage()
    local is_in_execute = health_percentage < execute_hp or
        enemy:get_health_percentage_inc(execute_deadline) < execute_hp

    return is_in_execute, health
end

---Handles utility
---@param me game_object
---@return boolean success
local function utility(me)
    local pet = me:get_pet()

    --If auto raise dead is enabled and no pet is present summon it
    if menu.AUTO_RAISE_DEAD_CHECK:get_state() and not pet then
        if SPELLS.RAISE_DEAD:cast_safe(nil, "Summoning Ghoul (No Pet)") then
            return true
        end
    end

    --Automatically remix time if cooldowns are not active and are on cooldown
    local last_movement = time_since_last_movement_sec()

    --Check if player has artifact trait that allows casting while moving
    local can_cast_while_moving = me:has_aura(REMIX_CASTING_MOVE_BUFF_IDS)

    --Check if we should remix time
    local remix_time_valid = can_cast_while_moving or menu.validate_remix_time(last_movement)

    if remix_time_valid then
        --Check cooldowns are active
        local has_legion_of_souls = me:has_buff(BUFFS.LEGION_OF_SOULS)
        local has_abomination = unit_has_abomination(me)
        local has_apocalypse = unit_has_apocalypse(me)
        local has_unholy_assault = me:has_buff(BUFFS.UNHOLY_ASSAULT)
        local has_twisted_crusade = me:has_buff(SPELLS.ARTIFACT_TWISTED_CRUSADE:id())

        --Make sure no cooldowns are active
        local cooldowns_inactive =
            not has_legion_of_souls and not has_abomination
            and not has_apocalypse and not has_unholy_assault
            and not has_twisted_crusade

        --If cooldowns are inactive we can check if we should remix time
        if cooldowns_inactive then
            --Get the cooldown remaining time for each CD
            local abomination_cooldown_sec = SPELLS.RAISE_ABOMINATION:cooldown_remains()
            local legion_of_souls_cooldown_sec = SPELLS.LEGION_OF_SOULS:cooldown_remains()
            local apocalypse_cooldown_sec = SPELLS.APOCALYPSE:cooldown_remains()
            local unholy_assault_cooldown_sec = SPELLS.UNHOLY_ASSAULT:cooldown_remains()
            local twisted_crusade_cooldown_sec = SPELLS.ARTIFACT_TWISTED_CRUSADE:cooldown_remains()

            --Get the highest cooldown remaining time
            local max_cooldown_sec = math.max(
                abomination_cooldown_sec,
                legion_of_souls_cooldown_sec,
                apocalypse_cooldown_sec,
                unholy_assault_cooldown_sec,
                twisted_crusade_cooldown_sec
            )

            --Check if the highest cooldown remaining time is greater than or equal to the minimum cooldown time
            local should_remix_time = max_cooldown_sec >= MINIMUM_COOLDOWN_SEC

            --If the highest cooldown remaining time is greater than or equal to the minimum cooldown time, cast Remix Time
            if should_remix_time then
                if SPELLS.REMIX_TIME:cast_safe(nil, "Remix Time (Refresh Cooldowns)") then
                    return true
                end
            end
        end
    end

    return false
end

---Handles artifact powers secondary use abilities
---@param me game_object
---@param target game_object
---@param is_aoe boolean
---@return boolean success
local function artifact_powers(me, target, is_aoe)
    --Cast Twisted Crusade Felspike before it falls off
    local twisted_crusade_id = SPELLS.ARTIFACT_TWISTED_CRUSADE:id()
    local has_twisted_crusade = me:has_buff(twisted_crusade_id)

    --If Twisted Crusade is active check if we should cast Felspike
    if has_twisted_crusade then
        --Get the current GCD and account for ping to determine if we should cast Felspike
        --This is so we can felspike on the last possible GCD
        local minimum_twisted_crusade_remaining_sec = gcd + ping_sec

        --Get the remaining duration of Twisted Crusade
        local twisted_crusade_remaining_sec = me:buff_remains_sec(twisted_crusade_id)

        --If the remaining duration of Twisted Crusade is less than the minimum required duration, cast Felspike
        local should_felspike = twisted_crusade_remaining_sec < minimum_twisted_crusade_remaining_sec

        if should_felspike then
            if SPELLS.ARTIFACT_TWISTED_CRUSADE_FELSPIKE:cast() then -- We use cast instead of safe_cast because this spell's CD is shared with Twisted Crusade and is only off CD the moment Twisted Crusade is casted
                return true
            end
        end
    end

    --Check TTD before casting Twisted Crusade
    local ttd = is_aoe and izi.get_time_to_die_global() or target:get_time_to_death()
    local twisted_crusade_valid = is_aoe and menu.validate_twisted_crusade_aoe(ttd) or menu.validate_twisted_crusade(ttd)

    --Cast twisted crusade
    if twisted_crusade_valid and SPELLS.ARTIFACT_TWISTED_CRUSADE:cast_safe() then
        return true
    end

    return false
end

---Handles defensive spells
---@param me game_object
---@param target game_object
---@return boolean
local function defensives(me, target)
    ---@type unit_cast_opts
    local def_opts = { skip_gcd = true }

    --Anti-Magic Shell
    ---@type defensive_filters
    local anti_magic_shell_filters =
    {
        health_percentage_threshold_raw = menu.ANTI_MAGIC_SHELL_MAX_HP:get(),
        health_percentage_threshold_incoming = menu.ANTI_MAGIC_SHELL_FUTURE_HP:get(),
        magical_damage_percentage_threshold = 3.5
    }

    if SPELLS.ANTI_MAGIC_SHELL:cast_defensive(me, anti_magic_shell_filters, "Anti-Magic Shell", def_opts) then
        return true
    end

    ---Cast lichborne if the forecasted HP matches the configured threshhold
    ---@type defensive_filters
    local lichborne_filters =
    {
        block_time = 6,
        health_percentage_threshold_raw = menu.LICHBORNE_MAX_HP:get(),
        health_percentage_threshold_incoming = menu.LICHBORNE_MAX_FUTURE_HP:get()
    }

    if SPELLS.LICHBORNE:cast_defensive(me, lichborne_filters, "Lichborne", def_opts) then
        return true
    end

    ---Cast icebound fortitude if the forecasted HP matches the configured threshhold
    ---@type defensive_filters
    local icebound_filters =
    {
        health_percentage_threshold_raw = menu.ICEBOUND_FORTITUDE_MAX_HP:get(),
        health_percentage_threshold_incoming = menu.ICEBOUND_FORTITUDE_MAX_FUTURE_HP:get()
    }

    if SPELLS.ICEBOUND_FORTITUDE:cast_defensive(me, icebound_filters, "Icebound Fortitude", def_opts) then
        return true
    end

    --Cast Death Strike if we have Dark Succor proc and we actually will benefit from it
    local hp = me:get_health_percentage()
    local has_dark_succor = me:has_buff(BUFFS.DARK_SUCCOR)
    local validate_death_strike = has_dark_succor and menu.validate_death_strike_dark_succor or
        menu.validate_death_strike

    if validate_death_strike(hp) and SPELLS.DEATH_STRIKE:cast_safe(target, "Death Strike") then
        return true
    end

    return false
end

---Handles single target rotation
---@param me game_object
---@param target game_object
---@return boolean success
local function single_target(me, target)
    --Cooldowns
    --Get TTD to check if we should use CDs
    local ttd = target:time_to_die()
    local raise_abomination_valid = menu.validate_raise_abomination(ttd)
    local legion_of_souls_valid = menu.validate_legion_of_souls(ttd)
    local apocalypse_valid = menu.validate_apocalypse(ttd)
    local unholy_assault_valid = menu.validate_unholy_assault(ttd)

    local apocalypse_ready_soon = apocalypse_valid and
        SPELLS.APOCALYPSE:cooldown_remains() <= COOLDOWN_READY_SOON_SEC

    local raise_abomination_ready_soon = raise_abomination_valid and
        SPELLS.RAISE_ABOMINATION:cooldown_remains() <= COOLDOWN_READY_SOON_SEC

    --Cast Raise Abomination
    if raise_abomination_valid and SPELLS.RAISE_ABOMINATION:cast_safe() then
        return true
    end

    --Cast Legion of Souls
    if legion_of_souls_valid and SPELLS.LEGION_OF_SOULS:cast_safe() then
        return true
    end

    --Cast Festering Strike until you have 4 Festering Wounds if Apocalypse is ready or is about to be ready.
    if apocalypse_ready_soon then
        local festering_wounds_cap = 4
        local target_festering_wound_stacks = target:get_debuff_stacks(BUFFS.FESTERING_WOUND)
        local has_festering_wounds_cap = target_festering_wound_stacks >= festering_wounds_cap

        if not has_festering_wounds_cap then
            SPELLS.FESTERING_STRIKE:cast_safe(target)
            return true -- We always return true because we want to build festering wounds to 4 on the target
        end

        --Cast Apocalypse with 4 Festering Wounds.
        if SPELLS.APOCALYPSE:cast_safe() then
            return true
        end
    end

    --Cast Unholy Assault
    local apocalypse_active = unit_has_apocalypse(me)

    if apocalypse_active then
        if unholy_assault_valid and SPELLS.UNHOLY_ASSAULT:cast_safe() then
            return true
        end
    end

    --Cast Outbreak if Virulent Plague can be refreshed (pandemic) and Apocalypse or Raise Abomination have more than 7 seconds remaining on their cooldown.
    if target:debuff_remains_sec(BUFFS.VIRULENT_PLAGUE) < VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_SEC then
        local should_apply_plague = not apocalypse_ready_soon and not raise_abomination_ready_soon

        if should_apply_plague then
            if SPELLS.OUTBREAK:cast_safe(target, "Refreshing Virulent Plague") then
                return true
            end
        end
    end

    --Cast Festering Scythe off cooldown
    if SPELLS.FESTERING_SCYTHE:cast_safe(target) then
        return true
    end

    --Cast Soul Reaper if the enemy is below 35% health or will be when this expires.
    if SPELLS.SOUL_REAPER:cooldown_up() then -- We check if the cooldown is up to save calls to health_prediction
        if should_soul_reaper(target) then
            if SPELLS.SOUL_REAPER:cast_safe(target) then
                return true
            end
        end
    end

    --Cast Death Coil when you have more than 80 Runic Power or when Sudden Doom is active.
    local death_coil_min_runic_power = 80
    local has_sudden_doom = me:has_buff(BUFFS.SUDDEN_DOOM)
    local should_death_coil = runic_power >= death_coil_min_runic_power or has_sudden_doom

    if should_death_coil then
        if SPELLS.DEATH_COIL:cast_safe(target) then
            return true
        end
    end

    --Cast Clawing Shadows when you have 1 or more Festering Wounds and Rotten Touch is on the target.
    local target_has_festering_wound = target:has_debuff(BUFFS.FESTERING_WOUND)
    local target_has_rotten_touch = target:has_debuff(BUFFS.ROTTEN_TOUCH)
    local should_clawing_shadows = target_has_festering_wound and target_has_rotten_touch

    if should_clawing_shadows then
        if SPELLS.CLAWING_SHADOWS:cast_safe(target) then
            return true
        end
    end

    --Cast Festering Strike when you have 2 or less Festering Wounds.
    --While Raise Abomination is active, you only cast Festering Strike when you are at 0 Festering Wounds
    local has_abomination = unit_has_abomination(me)
    local maximum_festering_wounds = has_abomination and 0 or 2
    local target_festering_wound_stacks = target:get_debuff_stacks(BUFFS.FESTERING_WOUND)
    local should_festering_strike = target_festering_wound_stacks <= maximum_festering_wounds

    if should_festering_strike then
        if SPELLS.FESTERING_STRIKE:cast_safe(target) then
            return true
        end
    end

    --Cast Death Coil if Death Rot is about to fall off.
    local minimum_death_rot_remaining_sec = gcd + ping_sec
    local death_rot_remaining_sec = target:debuff_remains_sec(BUFFS.DEATH_ROT)
    local should_refresh_death_rot = minimum_death_rot_remaining_sec < death_rot_remaining_sec

    if should_refresh_death_rot then
        if SPELLS.DEATH_COIL:cast_safe(target, "Refreshing Death Rot") then
            return true
        end
    end

    --Cast Clawing Shadows when you have 3 or more Festering Wounds.
    if target_festering_wound_stacks >= 3 then
        if SPELLS.CLAWING_SHADOWS:cast_safe(target) then
            return true
        end
    end

    --Cast Death Coil.
    if SPELLS.DEATH_COIL:cast_safe(target) then
        return true
    end

    return false
end

---@param enemy game_object
---@return number|nil
local function festering_wound_filter(enemy)
    if enemy:has_debuff(BUFFS.FESTERING_WOUND) then
        return enemy:get_debuff_stacks(BUFFS.FESTERING_WOUND)
    end
end

---@param enemy game_object
---@return number|nil
local function find_soul_reaper_target(enemy)
    local in_execute, health = should_soul_reaper(enemy)

    if in_execute then
        return health
    end
end

---Handles AoE rotation
---@param me game_object
---@param target game_object -- Hud Target
---@param enemies game_object[] --- Enemies within 30yd
---@param enemies_melee game_object[] --- Enemies within melee range
---@return boolean
local function aoe(me, target, enemies, enemies_melee)
    local ttd = izi.get_time_to_die_global()
    local raise_abomination_valid = menu.validate_raise_abomination(ttd)
    local legion_of_souls_valid = menu.validate_legion_of_souls(ttd)
    local apocalypse_valid = menu.validate_apocalypse(ttd)
    local unholy_assault_valid = menu.validate_unholy_assault(ttd)

    --When you are in an AoE situation, you should switch to using Epidemic over Death Coil at 3 stacked targets. However, when you are talented into Improved Death Coil this changes to 4 stacked targets.
    local has_improved_death_coil = SPELLS.IMPROVED_DEATH_COIL:is_learned()
    local minimum_epidemic_targets = has_improved_death_coil and 4 or 3
    local virulent_plague_enemies = izi.enemies_if(8, function(enemy) return enemy:has_debuff(BUFFS.VIRULENT_PLAGUE) end)

    local epidemic_or_death_coil = #virulent_plague_enemies >= minimum_epidemic_targets and SPELLS.EPIDEMIC or
        SPELLS.DEATH_COIL

    -- Cast Festering Scythe if it is available.
    if SPELLS.FESTERING_SCYTHE:cast_safe(target) then
        return true
    end

    --Cast Soul Reaper if an enemy is below 35% health or will be when this expires.
    if SPELLS.SOUL_REAPER:cooldown_up() then -- We check if the cooldown is up to save calls to health_prediction
        if SPELLS.SOUL_REAPER:cast_target_if(enemies_melee, "min", find_soul_reaper_target) then
            return true
        end
    end

    --Cooldowns
    --Cast Raise Abomination
    if raise_abomination_valid and SPELLS.RAISE_ABOMINATION:cast_safe() then
        return true
    end

    --Cast Legion of Souls.
    if legion_of_souls_valid and SPELLS.LEGION_OF_SOULS:cast_safe() then
        return true
    end

    --Cast Apocalypse on the target with the least Festering Wounds.
    if apocalypse_valid and SPELLS.APOCALYPSE:cast_target_if_safe(enemies, "min", festering_wound_filter) then
        return true
    end

    --Cast Unholy Assault.
    if unholy_assault_valid and SPELLS.UNHOLY_ASSAULT:cast_safe(target) then
        return true
    end

    local has_death_and_decay = me:has_buff(BUFFS.DEATH_AND_DECAY)

    --Cast Clawing Shadows if Plaguebringer is not active.
    local has_plaguebringer = me:has_buff(BUFFS.PLAGUEBRINGER)

    if not has_plaguebringer then
        if SPELLS.CLAWING_SHADOWS:cast_safe(target, "Plaguebringer") then
            return true
        end
    end

    --Cast Outbreak if Virulent Plague or Frost Fever is missing on any target and Apocalypse have more than 7 seconds remaining on their cooldown.
    local apocalypse_off_cd_soon = SPELLS.APOCALYPSE:cooldown_remains() <= COOLDOWN_READY_SOON_SEC
    local apocalypse_not_ready_soon = not apocalypse_valid or apocalypse_off_cd_soon

    if apocalypse_not_ready_soon and izi.spread_dot(SPELLS.OUTBREAK, enemies, VIRULENT_PLAGUE_PANDEMIC_THRESHOLD_MS, nil, "Spread Plague") then
        return true
    end

    --Burst Phase
    if has_death_and_decay then
        --Cast Unholy Assault.
        if unholy_assault_valid and SPELLS.UNHOLY_ASSAULT:cast_safe(target) then
            return true
        end

        --Cast Epidemic or death coil if Sudden Doom is active.
        local has_sudden_doom = me:has_buff(BUFFS.SUDDEN_DOOM)

        if has_sudden_doom then
            if epidemic_or_death_coil:cast_safe(target, "sudden doom") then
                return true
            end
        end

        --Cast Clawing Shadows if any target has a Festering Wound prioritizing the highest stack.
        if SPELLS.CLAWING_SHADOWS:cast_target_if_safe(enemies, "max", festering_wound_filter) then
            return true
        end

        --Cast Epidemic or death coil if no targets have Festering Wounds.
        local festering_wound_enemy = get_first_festering_wound_enemy(enemies)

        if not festering_wound_enemy then
            if epidemic_or_death_coil:cast_safe(target, "no targets have festering wound") then
                return true
            end
        end

        --Cast Clawing Shadows.
        if SPELLS.CLAWING_SHADOWS:cast_safe(target) then
            return true
        end

        --Cast Epidemic or death coil.
        if epidemic_or_death_coil:cast_safe(target, "fallback") then
            return true
        end
    else --Building Phase
        --Cast Clawing Shadows if Trollbane's Chains of Ice is up.
        local active_trollbanes_enemy = get_trollbanes_enemy(enemies)

        if active_trollbanes_enemy then
            if SPELLS.CLAWING_SHADOWS:cast_safe(active_trollbanes_enemy) then
                return true
            end
        end

        --Cast Epidemic or death coil if you have less than 4 Runes or if Sudden Doom is active.
        local has_sudden_doom = me:has_buff(BUFFS.SUDDEN_DOOM)
        local should_epidemic_or_death_coil = has_sudden_doom or runes < 4

        if should_epidemic_or_death_coil then
            if epidemic_or_death_coil:cast_safe(target, "sudden death or less than 4 runes") then
                return true
            end
        end

        --Cast Death and Decay if it is missing.
        if SPELLS.DEATH_AND_DECAY:cast_safe(target) then -- TODO: Spell prediction for most hits
            return true
        end
    end

    return false
end

core.register_on_update_callback(function()
    --Check if the rotation is enabled
    if not menu:is_enabled() then
        return
    end

    --Get the local player
    local me = izi.me()

    --Check if the local player exists and is valid
    if not (me and me.is_valid and me:is_valid()) then
        return
    end

    --Update our commonly used values
    ping_ms = core.get_ping()
    ping_sec = ping_ms / 1000
    game_time_ms = izi.now_game_time_ms()
    gcd = me:gcd()
    runic_power = me:get_power(enums.power_type.RUNICPOWER)
    runes = me:get_power(enums.power_type.RUNES)

    --Update the local player's last movement time
    if me:is_moving() then
        last_movement_time_ms = game_time_ms
    end

    --Update the local player's last mounted time
    if me:is_mounted() then
        last_mounted_time_ms = game_time_ms
        return
    end

    --Delay actions after dismounting (prevent trying to summon pet for example while we wait for it to resummon when phasing out)
    local time_dismounted_ms = time_since_last_dismount_ms()

    if time_dismounted_ms < DISMOUNT_DELAY_MS then
        return
    end

    --If the rotation is paused let's return early
    if not menu:is_rotation_enabled() then
        return
    end

    --Get enemies that are in combat within 30 yards
    local enemies = me:get_enemies_in_range(30)

    --Get enemies within melee range
    local enemies_melee = me:get_enemies_in_melee_range(8)

    --Check if we are in an AoE scenario
    local is_aoe = #enemies > 1

    --Execute our utils
    if utility(me) then
        return
    end

    --Get target selector targets
    local targets = izi.get_ts_targets()

    --Iterate over targets and run rotation logic
    for i = 1, #targets do
        local target = targets[i]

        --Check if the target is valid otherwise skip it
        if not (target and target.is_valid and target:is_valid()) then
            goto continue
        end

        --If the target is immune to any damage, skip it
        if target:is_damage_immune(target.DMG.ANY) then
            goto continue
        end

        --If the target is in a CC that breaks from damage, skip it
        if target:is_cc_weak() then
            goto continue
        end

        --Execute our defensives
        if defensives(me, target) then
            return
        end

        --Execute artifact powers (Lemix)
        if artifact_powers(me, target, is_aoe) then
            return
        end

        --Damage rotaion
        if is_aoe then
            --If we are in aoe lets call our AoE handler
            if aoe(me, target, enemies, enemies_melee) then
                return
            end
        else
            --If we are single target lets call our single target handler
            if single_target(me, target) then
                return
            end
        end

        --Our continue label to jump to the next target if previous checks fail
        ::continue::
    end
end)
