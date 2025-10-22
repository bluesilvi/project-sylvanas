
-- Example:
-- ---@type health_prediction
-- local x = require("common/modules/health_prediction")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class damage_type_enum
---@field public PHYSICAL_DAMAGE number[]
---@field public MAGICAL_DAMAGE number[]

---@class damage_types_table
---@field public physical_damage number[]
---@field public magical_damage number[]

---@class health_prediction
--- Get incoming damage on a target within a deadline.
---@field public get_incoming_damage fun(self: nil, target: game_object, deadline_time_in_seconds?: number, is_exception?: boolean): number
--- Check if the current situation is a PvP situation.
---@field public is_pvp_situation fun(self: nil, target: game_object): boolean
--- Speculate the auto attack damage.
---@field public speculate_auto_attack_damage fun(self: nil, caster: game_object, target: game_object, damage: number, spell_id: number): number
--- Speculate the spell damage.
---@field public speculate_spell_damage fun(self: nil, caster: game_object, target: game_object, damage: number, spell_id: number): number
--- Get the role ID of the target.
---@field public get_role_id fun(self: nil, target: game_object): number
--- Check if the unit is a tank.
---@field public is_tank fun(self: nil, unit: game_object): boolean
--- Speculate the damage of a spell considering various factors.
---@field public speculate_damage fun(self: nil, caster: game_object, target: game_object, damage: number, spell_id: number): number
--- Get incoming damage on a target within a deadline.
---@field public get_damage_types fun(self: nil, target: game_object, deadline_time_in_seconds?: number, is_exception?: boolean): damage_types_table
