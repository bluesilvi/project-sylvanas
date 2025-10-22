
-- Example:
-- ---@type profiler
-- local x = require("common/modules/profiler")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class profiler
--- Starts the profiler for a specific key.
---@field public start fun(key: string): nil
--- Stops the profiler for a specific key and processes the recorded time.
---@field public stop fun(key: string, is_failed: boolean): nil

-- Example usage:
-- local spell_name = "icebound_fortitude"
-- ---@type profiler
-- local profiler = require("common/modules/profiler")
-- profiler.start(spell_name)
-- if spells.icebound_fortitude.logics(target) then
--     core.log_file("[Cast] [Time: " .. tostring(current_core_time) .. "] -> Icebound Fortitude \n")
--     -- Stop profiling since the spell cast succeeded
--     profiler.stop(spell_name)
--     -- Set defensive block time
--     plugin_helper:set_defensive_block_time(6.50)
--     -- Skip global cooldown
--     return
-- end
-- -- Stop profiling with failure since the spell cast failed
-- profiler.stop(spell_name, true)