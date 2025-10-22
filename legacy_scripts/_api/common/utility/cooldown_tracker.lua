
-- Example:
-- ---@type cooldown_tracker
-- local x = require("common/utility/cooldown_tracker")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

--- Cooldown Tracker Module
--- Provides functionality to track and manage cooldowns for spells.

---@class cooldown_tracker
---@field public has_any_relevant_defensive_up fun(self: cooldown_tracker, unit: game_object): boolean
---@field public is_spell_ready fun(self: cooldown_tracker, unit: game_object, spell_id: number): boolean
---@field public has_any_kick_up fun(self: cooldown_tracker, caster: game_object, target: game_object, include_los: boolean): boolean
---@field public is_any_kick_around fun(self: cooldown_tracker, enemy_list: table<game_object>, include_los: boolean): boolean
---@field public is_spell_castable_to_player fun(self: cooldown_tracker, spell_id: number, caster: game_object, target: game_object, include_los: boolean): boolean
---@field public is_spell_in_range fun(self: cooldown_tracker, spell_id: number, caster: game_object, target: game_object): boolean
---@field public is_spell_los fun(self: cooldown_tracker, spell_id: number, caster: game_object, target: game_object): boolean

-- Example Usage:
-- local tracker = require("common/utility/cooldown_tracker")
-- if tracker:has_any_relevant_defensive_up(unit) then
--     print("Relevant defensive is ready!")
-- end
--
-- if tracker:is_spell_ready(unit, spell_id) then
--     print("Spell is ready to cast!")
-- end
