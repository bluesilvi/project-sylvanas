
--- Example:
--- ---@type pvp_helper
--- local x = require("common/utility/pvp_helper")
--- x: -> IntelliSense
--- Warning: Access with ":", not "."

---@class pvp_helper
---@field public is_player fun(self: pvp_helper, unit: game_object): boolean
---@field public is_pvp_scenario fun(self: pvp_helper): boolean
---@field public cc_flags cc_flags_table
---@field public cc_flag_descriptions table<number, string>
---@field public cc_debuffs table<number, {debuff_id: number, debuff_name: string, flag: number, weak: boolean, immune: boolean, source: number}>
---@field public slow_debuffs table<number, {debuff_id: number, debuff_name: string, mult: number, source: number}>
---@field public cc_immune_buffs table<number, {buff_id: number, buff_name: string, flag: number, class: number, mult: number}>
---@field public slow_immune_buffs table<number, {buff_id: number, buff_name: string, class: number}>
---@field public damage_reduction_buff table<number, {buff_id: number, buff_name: string, flag: number, class: number, mult: number}>
---@field public burst_buffs table<number, {buff_id: number, buff_name: string, class: number}>
---@field public purgeable_buffs table<number, {buff_id: number, buff_name: string, priority: number, min_remaining: number}>
---@field public stealeable_buffs table<number, {buff_id: number, buff_name: string, priority: number, min_remaining: number}>

---@class pvp_helper
---@field public is_crowd_controlled fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?, source_filter: number?): boolean, number, number, boolean, boolean
---@field public is_crowd_controlled_weak fun(self: pvp_helper, unit: game_object, min_remaining: number?, source_filter: number?): boolean, number, number
---@field public get_unit_dr fun(self: pvp_helper, unit: game_object, cc_flag: number, hit_time: number): number
---@field public get_cc_reduction_mult fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public get_cc_reduction_percentage fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public has_cc_reduction fun(self: pvp_helper, unit: game_object, threshold: number?, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_cc_immune fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_slow fun(self: pvp_helper, unit: game_object, threshold: number?, min_remaining: number?, source_filter: number?): boolean, number, number
---@field public get_slow_percentage fun(self: pvp_helper, unit: game_object, min_remaining: number?, source_filter: number?): number, number
---@field public is_slow_immune fun(self: pvp_helper, unit: game_object, source_filter: number?, min_remaining: number?): boolean, number

---@class pvp_helper
---@field public get_damage_reduction_mult fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public get_damage_reduction_percentage fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public has_damage_reduction fun(self: pvp_helper, unit: game_object, threshold: number?, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_damage_immune fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): boolean, number, number

---@class pvp_helper
---@field public is_purgeable fun(self: pvp_helper, unit: game_object, min_remaining: number?): {is_purgeable: boolean, table: {buff_id: number, buff_name: string, priority: number, min_remaining: number}?, current_remaining_ms: number, expire_time: number}
---@field public is_stealable fun(self: pvp_helper, unit: game_object, min_remaining: number?): {is_stealable: boolean, table: {buff_id: number, buff_name: string, priority: number, min_remaining: number}?, current_remaining_ms: number, expire_time: number}

---@class pvp_helper
---@field public is_melee fun(self: pvp_helper, unit: game_object): boolean
---@field public is_disarmable fun(self: pvp_helper, unit: game_object, include_all: boolean?): boolean

---@class pvp_helper
---@field public has_burst_active fun(self: pvp_helper, unit: game_object, min_remaining: number?): boolean

---@class pvp_helper
---@field public get_combined_cc_descriptions fun(self: pvp_helper, type: number): string
---@field public get_combined_damage_type_descriptions fun(self: pvp_helper, type: number): string

---@class cc_flags_table
---@field public MAGICAL number
---@field public PHYSICAL number
---@field public ROOT number
---@field public STUN number
---@field public INCAPACITATE number
---@field public DISORIENT number
---@field public FEAR number
---@field public SAP number
---@field public CYCLONE number
---@field public KNOCKBACK number
---@field public SILENCE number
---@field public DISARM number
---@field public ANY number
---@field public ANY_BUT_ROOT number
---@field public combine fun(...: number): number

---@class damage_type_flags_table
---@field public PHYSICAL number
---@field public MAGICAL number
---@field public ANY number
---@field public combine fun(...: string): number
