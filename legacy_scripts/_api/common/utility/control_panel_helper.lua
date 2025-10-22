
-- Example:
-- ---@type control_panel_helper_helper
-- local x = require("common/utility/control_panel_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class control_panel_helper
--- Updates the control panel elements based on the menu.
---@field public on_update fun(self: control_panel_helper, menu: table): nil

---@class control_panel_helper
--- Inserts a toggle into the control panel table.
---@field public insert_toggle fun(self: control_panel_helper, control_panel_table: table, toggle_table: table, only_drag_drop: boolean?): boolean

---@class control_panel_helper
--- Inserts a toggle into the control panel table with display name and keybind element.
---@field public insert_toggle_ fun(self: control_panel_helper, control_panel_table: table, display_name: string, keybind_element: keybind | userdata, only_drag_drop: boolean?, no_drag_and_drop: boolean?): boolean

---@class control_panel_helper
--- Inserts a combo into the control panel table. 
--- Note: This function takes the whole table directly.
---@field public insert_combo fun(self: control_panel_helper, control_panel_table: table, combo_table: table, increase_index_key: userdata, only_drag_drop: boolean?): boolean

---@class control_panel_helper
--- Inserts a combo into the control panel table.
--- Note: This function takes the parameters instead of whole table.
---@field public insert_combo_ fun(self: control_panel_helper, control_panel_table: table, display_name: string, combobox_element: userdata, preview_value: any, max_items: number, increase_index_key: userdata, only_drag_drop: boolean?): boolean
