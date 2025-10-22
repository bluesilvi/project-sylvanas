
-- Example:
-- ---@type unit_helper
-- local x = require("common/utility/unit_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class unit_helper
--- Returns true if the given unit is a training dummy.
---@field public is_dummy fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Determine if the unit is in combat with certain exceptions.
---@field public is_in_combat fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Return true when the npc_id is inside a blacklist.  
--- For example, incorporeal being, which will be ignored by target selector.
---@field public is_blacklist fun(self: unit_helper, npc_id: number): boolean

---@class unit_helper
--- Determine if the unit is a boss with exceptions.
---@field public is_boss fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Determine if the unit is a valid enemy with exceptions.
---@field public is_valid_enemy fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Determine if the unit is a valid ally with exceptions.
---@field public is_valid_ally fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Returns the health percentage of the unit in format 0.0 to 1.0.
---@field public get_health_percentage fun(self: unit_helper, unit: game_object): number

---@class unit_helper
--- First = Health Percentage - Incoming Damage
--- Second = Incoming Damage
--- Third = Health Percentage Raw
--- Fourth = Incoming Damage Relative to Health (Incoming Percentage)
--- Calculate the health percentage of a unit considering incoming damage within a specified time frame.
--- local health_percentage_inc, incoming_damage, health_percentage_raw, incoming_damage_percentage = fnc()
---@field public get_health_percentage_inc fun(self: unit_helper, unit: game_object, time_limit: number?): number, number, number, number

---@class unit_helper
--- Determine the role ID of the unit (Tank, Dps, Healer).  
---@field public get_role_id fun(self: unit_helper, unit: game_object): number

---@class unit_helper
--- Determine if the unit is in the tank role.
---@field public is_tank fun(self: unit_helper, unit: game_object): boolean
--- Determine if the unit is in the healer role.
---@field public is_healer fun(self: unit_helper, unit: game_object): boolean
--- Determine if the unit is in the damage dealer role.
---@field public is_damage_dealer fun(self: unit_helper, unit: game_object): boolean

---@class unit_helper
--- Get the power percentage of the unit.  
--- https://wowpedia.fandom.com/wiki/Enum.PowerType
---@field public get_resource_percentage fun(self: unit_helper, unit: game_object, power_type: number): number

---@class unit_helper
--- Returns a list of enemies within a designated area.  
--- Note: This function is performance-friendly with lua core cache.
---@field public get_enemy_list_around fun(self: unit_helper, point: vec3, range: number, incl_out_combat?: boolean, incl_blacklist?: boolean, players_only?: boolean, include_dead?: boolean): table<game_object>

---@class unit_helper
--- Returns a list of allies within a designated area.  
--- Note: This function is performance-friendly with lua core cache.
---@field public get_ally_list_around fun(self: unit_helper, point: vec3, range: number, players_only: boolean, party_only: boolean, include_dead?: boolean): table<game_object>
