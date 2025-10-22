
-- Example:
-- ---@type key_helper
-- local x = require("common/utility/key_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class key_helper
--- Function to get the name of a key based on its key code.
---@field public get_key_name fun(self: key_helper, key_code: number): string
