--[[
    Legacy Fire Mage rotation ported to IZI SDK

    This example demonstrates:
    - AoE detection and splash range calculations
    - Defensive checks (damage immunity, CC-weak states)
    - Menu element creation and rendering
    - Control panel integration with keybinds
    - Basic rotation logic (Flamestrike for AoE, Fireball for single target)

    Author: Voltz
]]

--Import libraries
local izi = require("common/izi_sdk")
local enums = require("common/enums")
local key_helper = require("common/utility/key_helper")
local control_panel_helper = require("common/utility/control_panel_helper")

--Lets create our own variable for buffs as we will typically access buff enums frequently
local buffs = enums.buff_db

--Constants
local AOE_RADIUS = 8 --The distance to scan around the target for AoE check

--Create a table containing all of our spells
local SPELLS =
{
    FIREBALL = izi.spell(133),    --Create our izi_spell object for fireball
    FLAMESTRIKE = izi.spell(2120) --Create our izi_spell object for flamestrike
}

--Settings prefix so we do not conflict with other plugins
local TAG = "izi_fire_mage_example_"

--Create our menu elements
local menu =
{
    --The tree for our menu elements
    root            = core.menu.tree_node(),

    --The global plugin enabled toggle
    enabled         = core.menu.checkbox(false, TAG .. "enabled"),

    --Hotkey to toggle the rotation on and off
    -- 7 "Undefined"
    -- 999 "Unbinded" but functional on control panel (allows people to click it without key bound)
    toggle_key      = core.menu.keybind(999, false, TAG .. "toggle"),

    --Toggle to only cast flamestrike when we can instant cast it
    fs_only_instant = core.menu.checkbox(false, TAG .. "fs_only_instant"),
}

--Checks to see if the plugin AND rotation is enabled
---@return boolean enabled
local function rotation_enabled()
    --We use get_toggle_state instead of get_state for the hotkey
    --because otherwise it will only be true if the key is held
    return menu.enabled:get_state() and menu.toggle_key:get_toggle_state()
end

--Register Callbacks
--Our menu render callback
core.register_on_render_menu_callback(function()
    --Draw our menu tree and the children inside it
    menu.root:render("Fire Mage (IZI Demo)", function()
        --Draw our plugin enabled checkbox
        menu.enabled:render("Enabled Plugin")

        --No need to render the rest of our items if we have the plugin disabled entirely
        if not menu.enabled:get_state() then
            return
        end

        --Draw our toggle rotation hotkey
        menu.toggle_key:render("Toggle Rotation")

        --Draw our flamestrike only when instant checkbox
        menu.fs_only_instant:render("Cast flamestrike only when instant")
    end)
end)

--Our control panel render callback
core.register_on_render_control_panel_callback(function()
    --Create our control_panel_elements
    local control_panel_elements = {}

    --Check that the plugin is enabled
    if not menu.enabled:get_state() then
        --We return the empty table because there is no reason to draw anything
        --in the control panel if the plugin is not enabled
        return control_panel_elements
    end

    --Insert our rotation toggle into the control panel
    control_panel_helper:insert_toggle(control_panel_elements,
        {
            --Name is the name of the toggle in the control panel
            --We format it to display the current keybind
            name = string.format("[IZI Fire Mage] Enabled (%s)",
                key_helper:get_key_name(menu.toggle_key:get_key_code())
            ),
            --The menu element for the hotkey
            keybind = menu.toggle_key
        })

    return control_panel_elements --Return our elements to tell the control panel what to draw
end)

--Our main loop, this is executed every game tick
core.register_on_update_callback(function()
    --Fire control_panel_helper update to keep our control panel updated
    control_panel_helper:on_update(menu)

    --Rotation is not toggled no need to execute the rotation logic
    if not rotation_enabled() then
        return
    end

    --Get the local player
    local me = izi.me()

    --If the local player is nil (not in the world, etc), we will abort execution
    if not me then
        return
    end

    --Grab the targets from the target selector
    local targets = izi.get_ts_targets()

    --Loop through all targets and run our logic on each one
    --We do this because targets[1] will always be the best target
    --But in case we can't cast anything on the primary target it will fall back to the next target
    for i = 1, #targets do
        local target = targets[i]

        --Check if the target is valid otherwise skip it
        if not (target and target.is_valid and target:is_valid()) then
            goto continue
        end

        --If the target is immune to magical damage, skip it
        if target:is_damage_immune(target.DMG.MAGICAL) then
            goto continue
        end

        --If the target is in a CC that breaks from damage, skip it
        if target:is_cc_weak() then
            goto continue
        end

        --Get number of enemies that are within splash range (radius + bounding) of the target in AOE_RADIUS
        --If you need more advanced logic and need access the enemies
        --you can use get_enemies_in_splash_range_count instead
        local total_enemies_around_target = target:get_enemies_in_splash_range_count(AOE_RADIUS)

        --Check for AoE scenarios and do AoE rotation
        if total_enemies_around_target > 1 then
            --Check if flamestrike is instant by getting if the player has hot streak or hyperthermia buff
            local is_flamestrike_instant = me:buff_up(buffs.HOT_STREAK) or me:buff_up(buffs.HYPERTHERMIA)

            --Check if the user only wants to cast flamestrike when it is instant
            local should_cast_flamestrike = not menu.fs_only_instant:get_state() or is_flamestrike_instant

            if should_cast_flamestrike then
                --Cast flamestrike at the most hits location
                if SPELLS.FLAMESTRIKE:cast_safe(target, "AoE: Flamestrike",
                        {
                            --Spell prediction is used by default for ground spells
                            --I am manually setting options to show that you can tweak the default behavior
                            --IZI should have default prediction options for most AoE spells, however, to get the most of your rotation you should tweak these values to fit your usage
                            --Use spell prediction (Default: True)
                            use_prediction  = true,
                            --Spell prediction type
                            prediction_type = "MOST_HITS",
                            --Geometry type (shape of the ground spell)
                            geometry        = "CIRCLE",
                            --Radius of the circle
                            aoe_radius      = 8,
                            --Minimum number of hits required for the spell to be cast
                            --(You could make this more advanced and calculate a min % of total enemies)
                            min_hits        = 2,
                            --Cast time is instant if we have hot streak otherwise izi will look it up
                            cast_time       = is_flamestrike_instant and 0 or nil,
                            --Cast while moving if we have hot streak up
                            skip_moving     = is_flamestrike_instant,
                            --Ensure we have LoS
                            --(changing to false as at the time of writing this it was not functioning correctly)
                            check_los       = false,
                        })
                then
                    --We have queued / casted a spell we should now return
                    --to rerun the logic to get the next priority spell
                    return
                end
            end

            --...Add more AoE logic
            --(above and below flamestrike depending on order / priority of your class rotation)
        end

        --Single target logic
        --Cast fireball
        if SPELLS.FIREBALL:cast_safe(target, "Single Target: Fireball") then
            --We have queued / casted a spell we should now return
            --to rerun the logic to get the next priority spell
            return
        end

        --...Add more single target logic
        --(above and below fireball depending on order / priority of your class rotation)

        --Define our continue label for continuing to the next target
        ::continue::
    end
end)
