
-- Example:
-- ---@type buff_manager
-- local x = require("common/modules/buff_manager")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class buff_manager_data
---@field public is_active boolean
---@field public remaining number
---@field public stacks number

---@class buff_manager_cache_data
---@field public buff_id number
---@field public count number
---@field public expire_time number
---@field public duration number
---@field public caster userdata
---@field public buff_name string
---@field public buff_type number
---@field public is_undefined boolean

---@class buff_manager
--- Gets the aura data for a unit, with caching.
---@field public get_aura_data fun(self: buff_manager, unit: game_object, enum_key: buff_db, custom_cache_duration?: number): buff_manager_data
--- Gets the buff data for a unit, with caching.
---@field public get_buff_data fun(self: buff_manager, unit: game_object, enum_key: buff_db, custom_cache_duration?: number): buff_manager_data
--- Gets the debuff data for a unit, with caching.
---@field public get_debuff_data fun(self: buff_manager, unit: game_object, enum_key: buff_db, custom_cache_duration?: number): buff_manager_data
--- Gets the buff cache for a unit.
---@field public get_buff_cache fun(self: buff_manager, unit: game_object, custom_cache_duration?: number): buff_manager_cache_data[]
--- Gets the debuff cache for a unit.
---@field public get_debuff_cache fun(self: buff_manager, unit: game_object, custom_cache_duration?: number): buff_manager_cache_data[]
--- Gets the aura cache for a unit.
---@field public get_aura_cache fun(self: buff_manager, unit: game_object, custom_cache_duration?: number): buff_manager_cache_data[]

---@class buff_manager
--- Check if the spell is currently on cooldown.
---@field public get_buff_value_from_description fun(self: buff_manager, description_text: string, ignore_percentage: boolean, ignore_flat: boolean): number
