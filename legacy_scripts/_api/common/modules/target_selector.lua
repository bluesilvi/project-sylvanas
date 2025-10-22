
-- Example:
-- ---@type target_selector
-- local x = require("common/modules/target_selector")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class target_selector
--- Correct way to get targets list.
---@field public get_targets fun(self: nil, limit: number?): table<game_object>
--- Correct way to get heal targets list.
---@field public get_targets_heal fun(self: nil, limit: number?): table<game_object>
--- Table containing all target_selector menu_elements
---@field public menu_elements table
