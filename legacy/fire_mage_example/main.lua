-- Note:
-- Keep in mind this is an example the core already has fire mage loaded by default
-- So in order to try this code properly you should disable default mage fire plugin

-- Note:
-- This is an intentionally simplified code example.
-- All logic shown here is for demonstration purposes only and may not cover all scenarios.
-- Use these examples as a starting point and adapt as needed for real implementations.

-- Use this file as a general example to build your own code.
-- in this file, the following example functionalities are provided:

-- 1 -> create basic menu elements for the script and interact with them
-- 2 -> import the necessary Lua modules provided by the core developers
-- 3 -> cast a fireball to the target selector main target, if we are in a single-target situation, flamestrike if we are in an aoe situation.

-- first, let's include all required modules:
local enums = require("common/enums")
local pvp_utility = require("common/utility/pvp_helper")
local spell_queue = require("common/modules/spell_queue")
local unit_helper = require("common/utility/unit_helper")
local spell_helper = require("common/utility/spell_helper")
local buff_manager = require("common/modules/buff_manager")
local plugin_helper = require("common/utility/plugin_helper")
local spell_prediction = require("common/modules/spell_prediction")
local control_panel_helper = require("common/utility/control_panel_helper")

-- then, let's define some menu elements:
local menu_elements =
{
    main_tree = core.menu.tree_node(),
    keybinds_tree_node = core.menu.tree_node(),
    enable_script_check = core.menu.checkbox(false, "enable_script_check"),
    cast_flamestrike_only_when_instant = core.menu.checkbox(false, "cast_flamestrike_only_when_instant"),

    -- 7 "Undefined"
    -- 999 "Unbinded" but functional on control panel (so newcomer can see it and click)
    enable_toggle = core.menu.keybind(999, false, "toggle_script_check"),

    draw_plugin_state = core.menu.checkbox(true, "draw_plugin_state"),
    ts_custom_logic_override = core.menu.checkbox(true, "override_ts_logic")
}

-- and now render them:
local function my_menu_render()
    -- this is the node that will appear in the main memu, under the name "Placeholder Script Menu"
    menu_elements.main_tree:render("Fire Mage Example", function()
        -- this is the checkbohx that will appear upon opening the previous tree node
        menu_elements.enable_script_check:render("Enable Script")

        --  if the script is not enabled, then we can stop rendering the following menu elements
        if not menu_elements.enable_script_check:get_state() then
            return false
        end

        menu_elements.keybinds_tree_node:render("Keybinds", function()
            menu_elements.enable_toggle:render("Enable Script Toggle")
        end)

        menu_elements.ts_custom_logic_override:render("Enable TS Custom Settings Override")
        menu_elements.cast_flamestrike_only_when_instant:render("Only Allow Flamestrike Cast When Empowered")
        menu_elements.draw_plugin_state:render("Draw Plugin State")
    end)
end

-- lets craft a function to cast a fireball

-- first, define the spell datas
local fireball_spell_data =
{
    id = 133,
    name = "Fireball",

    -- add the extra information that you might find useful here (...)
}

local flamestrike_spell_data =
{
    id = 2120,
    name = "Flamestrike",

    -- add the extra information that you might find useful here (...)
}

local last_fireball_cast_time = 0.0

---@param local_player game_object
---@param target game_object
---@return boolean
local function cast_fireball(local_player, target)
    local time = core.time()
    -- add this check to avoid multiple calls to the same function
    if time - last_fireball_cast_time < 0.20 then
        return false
    end

    -- check if the spell is ready and we can cast it to the current target
    local is_spell_ready_to_be_casted = spell_helper:is_spell_castable(fireball_spell_data.id, local_player, target,
        false, false)
    if not is_spell_ready_to_be_casted then
        return false
    end

    -- dont cast if we are moving!
    if local_player:is_moving() then
        return false
    end

    spell_queue:queue_spell_target(fireball_spell_data.id, target, 1, "Casting Fireball To " .. target:get_name())
    last_fireball_cast_time = time

    return true
end

---@param local_player game_object
---@return boolean
local function is_flamestrike_instant(local_player)
    -- if you don't find the buff that you are looking for in the buff_db enum, you can send custom table.

    -- how to send custom table:
    -- local hot_streak = {333}
    -- in this example hot_streak is the same as enums.buff_db.HOT_STREAK
    -- feel free to report us any missing buff / debuff on enums.buff_db and we will add it for you <3

    -- note: why is it a table and not a number alone? because maybe one buff / debuff has multiple ids

    -- store the information of the buff cache
    local hot_streak_data = buff_manager:get_buff_data(local_player, enums.buff_db.HOT_STREAK)

    -- use the boolean inside "is_active", you also have .remaining returning in milliseconds format and .stacks
    if hot_streak_data.is_active then
        return true
    end

    -- we check one buff first, this way in case this buff is true, we no longer need to pay resources to check the 2nd one.

    local hyperthermia_data = buff_manager:get_buff_data(local_player, enums.buff_db.HYPERTHERMIA)
    if hyperthermia_data.is_active then
        return true
    end

    return false
end

local last_flamestrike_cast_time = 0.0

---@param local_player game_object
---@param target game_object
---@return boolean
local function cast_flamestrike(local_player, target)
    local time = core.time()
    -- add this check to avoid multiple calls to the same function
    if time - last_flamestrike_cast_time < 0.20 then
        return false
    end

    local is_instant = is_flamestrike_instant(local_player)
    local is_only_casting_if_instant = menu_elements.cast_flamestrike_only_when_instant:get_state()
    if is_only_casting_if_instant then
        if not is_instant then
            return false
        end
    end

    -- dont cast if we are moving!
    if not is_flamestrike_instant then
        if local_player:is_moving() then
            return false
        end
    end

    -- check if the spell is ready and we can cast it to the current target
    local is_spell_ready_to_be_casted = spell_helper:is_spell_castable(flamestrike_spell_data.id, local_player, target,
        false, false)
    if not is_spell_ready_to_be_casted then
        return false
    end

    local flamestrike_radius = 8.0
    local flamestrike_radius_safe = flamestrike_radius * 0.90

    local flamestrike_range = 40
    local flamestrike_range_safe = flamestrike_range * 0.95

    local flamestrike_cast_time = 2.5
    local flamestrike_cast_time_safe = flamestrike_cast_time + 0.1

    local player_position = local_player:get_position()

    local prediction_spell_data = spell_prediction:new_spell_data(
        flamestrike_spell_data.id,                  -- spell_id
        flamestrike_range_safe,                     -- range
        flamestrike_radius_safe,                    -- radius
        flamestrike_cast_time_safe,                 -- cast_time
        0.0,                                        -- projectile_speed
        spell_prediction.prediction_type.MOST_HITS, -- prediction_type
        spell_prediction.geometry_type.CIRCLE,      -- geometry_type
        player_position                             -- source_position
    )

    local prediction_result = spell_prediction:get_cast_position(target, prediction_spell_data)
    if prediction_result.amount_of_hits <= 0 then
        return false
    end

    local cast_position = prediction_result.cast_position
    local cast_distance = cast_position:squared_dist_to(player_position)
    if cast_distance >= flamestrike_range then
        return false
    end

    spell_queue:queue_spell_position(flamestrike_spell_data.id, cast_position, 1,
        "Casting Flamestrike To " .. target:get_name())
    last_flamestrike_cast_time = time
    return true
end

-- Note:
-- This is an intentionally simplified code example.
-- All logic shown here is for demonstration purposes only and may not cover all scenarios.
-- Use these examples as a starting point and adapt as needed for real implementations.

---@param target game_object
---@return boolean
local function is_aoe(target)
    -- in range add the spell radius, in this case it's aprox 15 I suppose (didn't test)
    local units_around_target = unit_helper:get_enemy_list_around(target:get_position(), 15.0)
    return #units_around_target > 1
end

local function complete_cast_logic(local_player, target)
    -- flamestrike has priority over fireball.
    if is_aoe(target) then
        if cast_flamestrike(local_player, target) then
            return true
        end
    end

    -- if flamestrike wasn't casted, it means that either the target was alone (no aoe situation) or
    -- it means that flamestrike wasn't instant and the user set the "cast_flamestrike_only_when_instant" option
    -- to true
    return cast_fireball(local_player, target)
end

local target_selector = require("common/modules/target_selector")

-- this function is a simple one, not necessarily the best one for mage fires. This is just an example.
local is_ts_overriden = false
local function override_ts_settings()
    if is_ts_overriden then
        return
    end

    local is_override_allowed = menu_elements.ts_custom_logic_override:get_state()
    if not is_override_allowed then
        return
    end

    target_selector.menu_elements.settings.max_range_damage:set(40)

    target_selector.menu_elements.damage.weight_multiple_hits:set(true)
    target_selector.menu_elements.damage.slider_weight_multiple_hits:set(4)
    target_selector.menu_elements.damage.slider_weight_multiple_hits_radius:set(8)

    is_ts_overriden = true
end

local function my_on_update()
    -- Control Panel Drag & Drop
    control_panel_helper:on_update(menu_elements)

    -- no local player usually means that the user is in loading screen / not ingame
    local local_player = core.object_manager.get_local_player()
    if not local_player then
        return
    end

    -- check if the user disabled the script
    if not menu_elements.enable_script_check:get_state() then
        return
    end

    if not plugin_helper:is_toggle_enabled(menu_elements.enable_toggle) then
        return
    end

    local cast_end_time = local_player:get_active_spell_cast_end_time()
    if cast_end_time > 0.0 then
        return false
    end

    local channel_end_time = local_player:get_active_channel_cast_end_time()
    if channel_end_time > 0.0 then
        return false
    end

    -- do not run the rotation code while in mount, so you dont auto dismount by mistake
    if local_player:is_mounted() then
        return
    end

    -- NOTE: you should override the target selector settings according to your script requirements. You shouldn't leave these configuration
    -- options entirely to your users, since you are the one crafting the magical script, and you are the one who knows which settings will
    -- work best, according to your code. To see how to do this properly, check the Target Selector - Dev guide.
    override_ts_settings()

    -- Get all targets from the target selector
    local targets_list = target_selector:get_targets()

    -- Core useful boolean to determine if defensive actions are allowed
    local is_defensive_allowed = plugin_helper:is_defensive_allowed()

    -- Defensive logic: typically run defensive spells before any offensive actions
    -- This is a good place to implement your defensive routines.
    -- You can cast basic defensive spells directly, or loop through targets if specific targeting is needed.
    for index, target in ipairs(targets_list) do
        if is_defensive_allowed then
            -- **Add defensive spells here**
            -- (...)

            -- After each defensive cast, consider setting a delay before the next one

            -- e.g
            -- local time_in_seconds = 0.50
            -- plugin_helper:set_defensive_block_time(time_in_seconds)
        end
    end

    -- Some classes have healing capabilities and may also want to apply defensive logic to teammates.

    -- Get all healing targets using the target selector
    local heal_targets_list = target_selector:get_targets_heal()

    for index, heal_target in ipairs(heal_targets_list) do
        if pvp_utility:is_crowd_controlled(heal_target, pvp_utility.cc_flags.combine("CYCLONE"), 100) then
            -- Avoid trying to heal a friend in cyclone
            -- this also include other cc like hunter pvp trap or dh pvp imprision
            -- Any known CC that makes you immune to damage and healing
            goto continue
        end

        -- Here you should not use is_defensive_allowed or set_defensive_block_time unless heal_target is local_player
        -- (...)

        ::continue::
    end

    -- target selector gives up to 3 targets, in order of priority according to the user's settings.
    for index, target in ipairs(targets_list) do
        local is_target_in_combat = unit_helper:is_in_combat(target)
        if not is_target_in_combat then
            -- check that the unit is in combat, if we don't attack out of combat mobs
            -- by default target selector should not send you units out of combat, but this can be changed and you decide here in code if you acept them
            goto continue
        end

        if pvp_utility:is_damage_immune(target, pvp_utility.damage_type_flags.MAGICAL) then
            -- We dont want to waste spells on immune damage units
            -- With pvp_utility.damage_type_flags.BOTH you can decide which type of damage you want to filter, in this case we filter immune to magical
            goto continue
        end

        if pvp_utility:is_crowd_controlled(target, pvp_utility.cc_flags.combine("DISORIENT", "INCAPACITATE", "SAP"), 1000) then
            -- We dont want to break CC like polymorph
            goto continue
        end

        -- this is where your spells logic functions should go
        -- (...)

        -- when we cast a spell, we can already return from this function, as this was its primary use. We don't need to
        -- keep reading more code for other targets, at least untill next frame.
        if complete_cast_logic(local_player, target) then
            return true
        end

        -- (...)
        ::continue::
    end
end

-- render the "Disabled" rectangle box when the user has the script toggled off
local function my_on_render()
    local local_player = core.object_manager.get_local_player()
    if not local_player then
        return
    end

    if not menu_elements.enable_script_check:get_state() then
        return
    end

    if not plugin_helper:is_toggle_enabled(menu_elements.enable_toggle) then
        if menu_elements.draw_plugin_state:get_state() then
            plugin_helper:draw_text_character_center("DISABLED")
        end
    end
end

local key_helper = require("common/utility/key_helper")
local function on_control_panel_render()
    -- Enable Toggle on Control Panel, Default Unbinded, still clickeable tho.

    local control_panel_elements = {}

    if not menu_elements.enable_script_check:get_state() then -- if the plugin is disabled we return the empty control_panel_elements
        return control_panel_elements
    end

    control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[" ..
            "MageTest" .. "] Enable (" .. key_helper:get_key_name(menu_elements.enable_toggle:get_key_code()) .. ") ",
            keybind = menu_elements.enable_toggle
        })

    return control_panel_elements
end

-- Register Callbacks
core.register_on_update_callback(my_on_update)
core.register_on_render_callback(my_on_render)
core.register_on_render_menu_callback(my_menu_render)
core.register_on_render_control_panel_callback(on_control_panel_render)
