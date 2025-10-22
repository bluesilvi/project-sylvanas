
-- Example:
-- ---@type plugin_helper
-- local x = require("common/utility/plugin_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class plugin_helper
--- Checks if a toggle menu element is enabled, taking special cases into account.
---@field public is_toggle_binded fun(self: plugin_helper, element: keybind): boolean

---@class plugin_helper
--- Checks if a toggle menu element is enabled, taking special cases into account.
---@field public is_toggle_enabled fun(self: plugin_helper, element: keybind): boolean

---@class plugin_helper
--- Checks if a keybind menu element is active, considering special cases.
---@field public is_keybind_enabled fun(self: plugin_helper, element: keybind): boolean

---@class plugin_helper
--- Draws centered text at the character's screen position with an optional vertical offset.
---@field public draw_text_character_center fun(self: plugin_helper, text: string, text_color: color?, y_offset: number?, is_static: boolean?)

---@class plugin_helper
--- Draws centered text at the character's screen position with an optional vertical offset.
--- text, text_color, border_color, screen_position, size
---@field public draw_text_message fun(self: plugin_helper, text: string, text_color: color, border_color: color, screen_position: vec2, size: vec2, is_static:boolean, add_rectangles: boolean, unique_id: string)

---@class plugin_helper
--- Calculates latency based on the current ping, clamped to a maximum value.
---@field public get_latency fun(self: plugin_helper): number

---@class plugin_helper
--- Retrieves the current combat lenght in core time.
---@field public get_current_combat_length_seconds fun(self: plugin_helper): number

---@class plugin_helper
--- Retrieves the current combat lenght in game time.
---@field public get_current_combat_length_miliseconds fun(self: plugin_helper): number

---@class plugin_helper
--- Determines if defensive actions are allowed based on a global variable.
---@field public is_defensive_allowed fun(self: plugin_helper): boolean

---@class plugin_helper
--- Retrieves the current defensive block time.
---@field public get_defensive_block_time fun(self: plugin_helper): number

---@class plugin_helper
--- Sets the defensive block time based on the given extra time.
---@field public set_defensive_block_time fun(self: plugin_helper, extra_time: number): nil
