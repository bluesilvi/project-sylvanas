
-- Example:
-- ---@type auto_attack_helper
-- local x = require("common/utility/auto_attack_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class auto_attack_helper
---@field attacks_logs table

---@class auto_attack_helper
--- Checks if the given spell ID is an auto attack.
---@field public is_spell_auto_attack fun(self: auto_attack_helper, spell_id: number): boolean
