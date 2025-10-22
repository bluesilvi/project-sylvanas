
-- Example:
-- ---@type spell_helper
-- local x = require("common/utility/spell_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class spell_helper
--- Check if the spell is in the spellbook.
---@field public has_spell_equipped fun(self: spell_helper, spell_id: number): boolean

---@class spell_helper
--- Check if the spell is currently on cooldown.
---@field public is_spell_on_cooldown fun(self: spell_helper, spell_id: number): boolean

---@class spell_helper
--- Check if a spell is within castable range given a target.
---@field public is_spell_in_range fun(self: spell_helper, spell_id: number, target: game_object, source: vec3, destination: vec3): boolean

---@class spell_helper
--- Check if the target is within a permissible angle for casting a spell.
---@field public is_spell_within_angle fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object, caster_position: vec3, target_position: vec3): boolean

---@class spell_helper
--- Check if the caster has the target in line of sight.
---@field public is_spell_in_line_of_sight fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object): boolean

---@class spell_helper
--- Check if the caster has the target in line of sight.
---@field public is_spell_in_line_of_sight_position fun(self: spell_helper, spell_id: number, caster: game_object, cast_position: vec3): boolean

---@class spell_helper
--- Retrieve the cost of a spell.
---@field public get_spell_cost fun(self: spell_helper, spell_id: number): table

---@class spell_helper
--- Check if a unit has enough resources to cast a spell.
---@field public can_afford_spell fun(self: spell_helper, unit: game_object, spell_id: number, spell_costs: table): boolean

---@class spell_helper
--- Check if the spell can be cast by considering various factors like cooldown, range, and caster's resources.
---@field public is_spell_castable fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object, skip_facing: boolean, skips_range: boolean): boolean

---@class spell_helper
--- Check if the spell can be cast (on position vec3) by considering various factors like cooldown, range, and caster's resources.
---@field public is_spell_castable_position fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object, cast_position: vec3, skip_facing: boolean, skips_range: boolean,  is_queue: boolean?): boolean

---@class spell_helper
--- Check if the spell can be cast by considering various factors like cooldown, range, and caster's resources.
---@field public is_spell_queueable fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object, skip_facing: boolean, skips_range: boolean): boolean

---@class spell_helper
--- Check if the spell is currently on cooldown.
---@field public get_spell_damage fun(self: spell_helper, spell_id: number, ignore_percentage?: boolean, ignore_flat?: boolean): number

---@class spell_helper
--- Check if the spell is currently on cooldown.
---@field public get_spell_healing fun(self: spell_helper, spell_id: number, ignore_percentage?: boolean, ignore_flat?: boolean): number
