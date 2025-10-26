--[[
    Unholy Death Knight Menu Configuration for IZI SDK

    This file contains all menu elements and configuration options for the Unholy Death Knight rotation.
    Users can customize rotation behavior through various settings organized into logical categories.

    Menu Categories:
    - Global settings (Plugin enable/disable)
    - Keybinds (Rotation toggle)
    - Cooldowns (TTD validation for major abilities)
    - Defensives (Health thresholds for defensive abilities)
    - Utility (Auto pet summon, Remix Time settings)

    Features:
    - Configurable TTD (Time To Die) thresholds for cooldown usage
    - Separate settings for single target and AoE scenarios
    - Health-based triggers for defensive abilities
    - Validator functions for easy integration with rotation logic
    - Control panel integration for in-game overlay

    Author: Voltz
]]

---@meta menu
local m = core.menu
local color = require("common/color")
local key_helper = require("common/utility/key_helper")
local control_panel_utility = require("common/utility/control_panel_helper")

--Constants
local PLUGIN_PREFIX = "celestial_dk_unholy"
local WHITE = color.white(150)
local TTD_MIN = 1
local TTD_MAX = 120
local TTD_DEFAULT = 16
local TTD_DEFAULT_AOE = 20

---Creates an ID with prefix for our rotation so we don't need to type it every time
---@param key string
local function id(key)
    return string.format("%s_%s", PLUGIN_PREFIX, key)
end

---@class unholy_dk_menu
local menu =
{
    --Global
    MAIN_TREE = m.tree_node(),
    GLOBAL_CHECK = m.checkbox(true, id("global_toggle")),

    --Keybinds
    KEYBIND_TREE = m.tree_node(),
    ROTATION_KEYBIND = m.keybind(999, false, id("rotation_toggle")),

    --Cooldowns
    COOLDOWNS_TREE = m.tree_node(),

    --Raise Abomination
    RAISE_ABOMINATION_TREE = m.tree_node(),
    RAISE_ABOMINATION_CHECK = m.checkbox(true, id("abomination_toggle")),
    RAISE_ABOMINATION_MIN_TTD = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT, id("abomination_min_ttd")),
    RAISE_ABOMINATION_MIN_TTD_AOE = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT_AOE, id("abomination_min_ttd_aoe")),

    --Apocalypse
    APOCALYPSE_TREE = m.tree_node(),
    APOCALYPSE_CHECK = m.checkbox(true, id("apocalypse_toggle")),
    APOCALYPSE_MIN_TTD = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT, id("apocalypse_min_ttd")),
    APOCALYPSE_MIN_TTD_AOE = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT_AOE, id("apocalypse_min_ttd_aoe")),

    --Legion of Souls
    LEGION_OF_SOULS_TREE = m.tree_node(),
    LEGION_OF_SOULS_CHECK = m.checkbox(true, id("legion_of_souls_toggle")),
    LEGION_OF_SOULS_MIN_TTD = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT, id("legion_of_souls_min_ttd")),
    LEGION_OF_SOULS_MIN_TTD_AOE = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT_AOE, id("legion_of_souls_min_ttd_aoe")),

    --Unholy Assault
    UNHOLY_ASSAULT_TREE = m.tree_node(),
    UNHOLY_ASSAULT_CHECK = m.checkbox(true, id("unholy_assault_toggle")),
    UNHOLY_ASSAULT_MIN_TTD = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT, id("unholy_assault_min_ttd")),
    UNHOLY_ASSAULT_MIN_TTD_AOE = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT_AOE, id("unholy_assault_min_ttd_aoe")),

    --Twisted Crusade
    TWISTED_CRUSADE_TREE = m.tree_node(),
    TWISTED_CRUSADE_CHECK = m.checkbox(true, id("twisted_crusade_toggle")),
    TWISTED_CRUSADE_MIN_TTD = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT, id("twisted_crusade_min_ttd")),
    TWISTED_CRUSADE_MIN_TTD_AOE = m.slider_float(TTD_MIN, TTD_MAX, TTD_DEFAULT_AOE, id("twisted_crusade_min_ttd_aoe")),

    --Defensives
    DEFENSIVES_TREE = m.tree_node(),

    --Anti-Magic Shell
    ANTI_MAGIC_SHELL_TREE = m.tree_node(),
    ANTI_MAGIC_SHELL_CHECK = m.checkbox(true, id("anti_magic_shell_toggle")),
    ANTI_MAGIC_SHELL_MAX_HP = m.slider_int(1, 100, 95, id("anti_magic_shell_max_hp")),
    ANTI_MAGIC_SHELL_FUTURE_HP = m.slider_int(1, 100, 90, id("anti_magic_shell_max_future_hp")),

    --Lichborne
    LICHBORNE_TREE = m.tree_node(),
    LICHBORNE_CHECK = m.checkbox(true, id("lichborne_toggle")),
    LICHBORNE_MAX_HP = m.slider_int(1, 100, 60, id("lichborne_max_hp")),
    LICHBORNE_MAX_FUTURE_HP = m.slider_int(1, 100, 55, id("lichborne_max_future_hp")),

    --Icebound Fortitude
    ICEBOUND_FORTITUDE_TREE = m.tree_node(),
    ICEBOUND_FORTITUDE_CHECK = m.checkbox(true, id("icebound_fortitude_toggle")),
    ICEBOUND_FORTITUDE_MAX_HP = m.slider_int(1, 100, 50, id("icebound_fortitude_max_hp")),
    ICEBOUND_FORTITUDE_MAX_FUTURE_HP = m.slider_int(1, 100, 45, id("icebound_fortitude_max_future_hp")),

    --Death Strike
    DEATH_STRIKE_TREE = m.tree_node(),
    DEATH_STRIKE_CHECK = m.checkbox(true, id("death_strike_toggle")),
    DEATH_STRIKE_MAX_HP = m.slider_int(1, 100, 55, id("death_strike_min_hp")),
    DEATH_STRIKE_DARK_SUCCOR_MAX_HP = m.slider_int(1, 100, 70, id("death_strike_dark_succor_max_hp")),

    --Utility
    UTILITY_TREE = m.tree_node(),
    AUTO_RAISE_DEAD_CHECK = m.checkbox(true, id("auto_raise_dead")),
    AUTO_REMIX_TIME_CHECK = m.checkbox(true, id("auto_remix_time")),
    AUTO_REMIX_TIME_MIN_TIME_STANDING = m.slider_float(0, 15, 2.5, id("auto_remix_time_min_time_standing"))
}

---@alias menu_validator_fn fun(value: number): boolean

---Creates a new validator function validating a checkbox and relevant slider value
---@param checkbox checkbox
---@param slider slider_int|slider_float
---@param type? "min"|"max"|"equal"
---@return menu_validator_fn
function menu.new_validator_fn(checkbox, slider, type)
    type = type or "min"

    return function(value)
        local is_checked = checkbox:get_state()

        if is_checked then
            local slider_value = slider:get()

            if type == "min" then
                return value >= slider_value
            elseif type == "max" then
                return value <= slider_value
            elseif type == "equal" then
                return value == slider_value
            end
        end

        return false
    end
end

--Returns true if the plugin is enabled
---@return boolean enabled
function menu:is_enabled()
    return self.GLOBAL_CHECK:get_state()
end

--Returns true if the plugin and rotation are enabled
---@return boolean enabled
function menu:is_rotation_enabled()
    return self.GLOBAL_CHECK:get_state() and self.ROTATION_KEYBIND:get_toggle_state()
end

--Alias our menu to M so its shorter when rendering and registering our validator functions
---@class unholy_dk_menu
local M = menu

core.register_on_render_menu_callback(function()
    M.MAIN_TREE:render("Celestial Unholy Death Knight", function()
        M.GLOBAL_CHECK:render("Plugin Enabled", "Global toggle for the plugin")

        if not M.GLOBAL_CHECK:get_state() then
            return
        end

        M.KEYBIND_TREE:render("Keybinds", function()
            M.ROTATION_KEYBIND:render("Rotation Enabled", "Toggles rotation on / off")
        end)

        M.COOLDOWNS_TREE:render("Cooldowns", function()
            M.RAISE_ABOMINATION_TREE:render("Abomination", function()
                M.RAISE_ABOMINATION_CHECK:render("Enabled", "Toggles Raise Abomination usage on / off")

                if M.RAISE_ABOMINATION_CHECK:get_state() then
                    M.RAISE_ABOMINATION_MIN_TTD:render("Min TTD",
                        "Minimum Time To Die (in seconds) to use Raise Abomination")

                    M.RAISE_ABOMINATION_MIN_TTD_AOE:render("Min TTD (AoE)",
                        "Minimum AoE TTD (in seconds) to use Raise Abomination")
                end
            end)

            M.APOCALYPSE_TREE:render("Apocalypse", function()
                M.APOCALYPSE_CHECK:render("Enabled", "Toggles Apocalypse usage on / off")

                if M.APOCALYPSE_CHECK:get_state() then
                    M.APOCALYPSE_MIN_TTD:render("Min TTD", "Minimum Time To Die (in seconds) to use Apocalypse")
                    M.APOCALYPSE_MIN_TTD_AOE:render("Min TTD (AoE)", "Minimum AoE TTD (in seconds) to use Apocalypse")
                end
            end)

            M.LEGION_OF_SOULS_TREE:render("Legion of Souls", function()
                M.LEGION_OF_SOULS_CHECK:render("Enabled", "Toggles Legion of Souls usage on / off")

                if M.LEGION_OF_SOULS_CHECK:get_state() then
                    M.LEGION_OF_SOULS_MIN_TTD:render("Min TTD", "Minimum Time To Die (in seconds) to use Legion of Souls")

                    M.LEGION_OF_SOULS_MIN_TTD_AOE:render("Min TTD (AoE)",
                        "Minimum AoE TTD (in seconds) to use Legion of Souls")
                end
            end)

            M.UNHOLY_ASSAULT_TREE:render("Unholy Assault", function()
                M.UNHOLY_ASSAULT_CHECK:render("Enabled", "Toggles Unholy Assault usage on / off")

                if M.UNHOLY_ASSAULT_CHECK:get_state() then
                    M.UNHOLY_ASSAULT_MIN_TTD:render("Min TTD", "Minimum Time To Die (in seconds) to use Unholy Assault")
                    M.UNHOLY_ASSAULT_MIN_TTD_AOE:render("Min TTD (AoE)",
                        "Minimum AoE TTD (in seconds) to use Unholy Assault")
                end
            end)

            M.TWISTED_CRUSADE_TREE:render("Twisted Crusade (Lemix)", function()
                M.TWISTED_CRUSADE_CHECK:render("Enabled", "Toggles Twisted Crusade usage on / off")

                if M.TWISTED_CRUSADE_CHECK:get_state() then
                    M.TWISTED_CRUSADE_MIN_TTD:render("Min TTD", "Minimum Time To Die (in seconds) to use Twisted Crusade")
                    M.TWISTED_CRUSADE_MIN_TTD_AOE:render("Min TTD (AoE)",
                        "Minimum AoE TTD (in seconds) to use Twisted Crusade")
                end
            end)
        end)

        M.DEFENSIVES_TREE:render("Defensives", function()
            M.ANTI_MAGIC_SHELL_TREE:render("Anti-Magic Shell", function()
                M.ANTI_MAGIC_SHELL_CHECK:render("Enabled", "Toggles Anti-Magic Shell usage on / off")
                M.ANTI_MAGIC_SHELL_MAX_HP:render("Max HP", "Maximum HP to use Anti-Magic Shell")
                M.ANTI_MAGIC_SHELL_FUTURE_HP:render("Max Future HP", "Maximum Future HP to use Anti-Magic Shell")
            end)

            M.LICHBORNE_TREE:render("Lichborne", function()
                M.LICHBORNE_CHECK:render("Enabled", "Toggles Lichborne usage on / off")
                M.LICHBORNE_MAX_HP:render("Max HP", "Maximum HP to use Lichborne")
                M.LICHBORNE_MAX_FUTURE_HP:render("Max Future HP", "Maximum Future HP to use Lichborne")
            end)

            M.ICEBOUND_FORTITUDE_TREE:render("Icebound Fortitude", function()
                M.ICEBOUND_FORTITUDE_CHECK:render("Enabled", "Toggles Icebound Fortitude usage on / off")
                M.ICEBOUND_FORTITUDE_MAX_HP:render("Max HP", "Maximum HP to use Icebound Fortitude")
                M.ICEBOUND_FORTITUDE_MAX_FUTURE_HP:render("Max Future HP", "Maximum Future HP to use Icebound Fortitude")
            end)

            M.DEATH_STRIKE_TREE:render("Death Strike", function()
                M.DEATH_STRIKE_CHECK:render("Enabled", "Toggles Death Strike usage on / off")
                M.DEATH_STRIKE_MAX_HP:render("Max HP", "Minimum HP to use Death Strike")
                M.DEATH_STRIKE_DARK_SUCCOR_MAX_HP:render("Max HP (Dark Succor)",
                    "Maximum HP to use Death Strike with Dark Succor")
            end)
        end)

        M.UTILITY_TREE:render("Utility", function()
            M.AUTO_RAISE_DEAD_CHECK:render("Auto Raise Dead", "Automatically summon ghoul")
            M.AUTO_REMIX_TIME_CHECK:render("Auto Remix Time (Lemix)", "Automatically Remix Time")

            if M.AUTO_REMIX_TIME_CHECK:get_state() then
                M.AUTO_REMIX_TIME_MIN_TIME_STANDING:render("Remix Min Standing",
                    "Minimum time (in seconds) standing to use Remix Time")
            end
        end)
    end)
end)

core.register_on_render_control_panel_callback(function()
    local rotation_toggle_key = M.ROTATION_KEYBIND:get_key_code()
    local rotation_toggle =
    {
        name = string.format("[Celestial] Enabled (%s)", key_helper:get_key_name(rotation_toggle_key)),
        keybind = M.ROTATION_KEYBIND
    }

    local control_panel_elements = {}

    if M:is_enabled() then
        control_panel_utility:insert_toggle_(control_panel_elements, rotation_toggle.name, rotation_toggle.keybind, false)
    end

    return control_panel_elements
end)

--Cooldown Validators
M.validate_raise_abomination = M.new_validator_fn(M.RAISE_ABOMINATION_CHECK, M.RAISE_ABOMINATION_MIN_TTD)
M.validate_raise_abomination_aoe = M.new_validator_fn(M.RAISE_ABOMINATION_CHECK, M.RAISE_ABOMINATION_MIN_TTD_AOE)
M.validate_apocalypse = M.new_validator_fn(M.APOCALYPSE_CHECK, M.APOCALYPSE_MIN_TTD)
M.validate_apocalypse_aoe = M.new_validator_fn(M.APOCALYPSE_CHECK, M.APOCALYPSE_MIN_TTD_AOE)
M.validate_legion_of_souls = M.new_validator_fn(M.LEGION_OF_SOULS_CHECK, M.LEGION_OF_SOULS_MIN_TTD)
M.validate_legion_of_souls_aoe = M.new_validator_fn(M.LEGION_OF_SOULS_CHECK, M.LEGION_OF_SOULS_MIN_TTD_AOE)
M.validate_unholy_assault = M.new_validator_fn(M.UNHOLY_ASSAULT_CHECK, M.UNHOLY_ASSAULT_MIN_TTD)
M.validate_unholy_assault_aoe = M.new_validator_fn(M.UNHOLY_ASSAULT_CHECK, M.UNHOLY_ASSAULT_MIN_TTD_AOE)
M.validate_twisted_crusade = M.new_validator_fn(M.TWISTED_CRUSADE_CHECK, M.TWISTED_CRUSADE_MIN_TTD)
M.validate_twisted_crusade_aoe = M.new_validator_fn(M.TWISTED_CRUSADE_CHECK, M.TWISTED_CRUSADE_MIN_TTD_AOE)

--Defensive Validators
M.validate_death_strike = M.new_validator_fn(M.DEATH_STRIKE_CHECK, M.DEATH_STRIKE_MAX_HP, "max")
M.validate_death_strike_dark_succor = M.new_validator_fn(M.DEATH_STRIKE_CHECK, M.DEATH_STRIKE_DARK_SUCCOR_MAX_HP, "max")

--Util Validators
M.validate_remix_time = M.new_validator_fn(M.AUTO_REMIX_TIME_CHECK, M.AUTO_REMIX_TIME_MIN_TIME_STANDING)

return menu
