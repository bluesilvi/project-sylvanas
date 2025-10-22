
-- Example:
-- ---@type dungeons_helper
-- local x = require("common/utility/dungeons_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class dungeons_helper
---@field public is_heroic_dungeon fun(self: dungeons_helper): boolean
---@field public is_mythic_dungeon fun(self: dungeons_helper): boolean
---@field public is_mythic_plus_dungeon fun(self: dungeons_helper): boolean
---@field public get_mythic_scaling fun(self: dungeons_helper): number
---@field public get_mythic_key_level fun(self: dungeons_helper): number
---@field public is_kite_exception fun(self: dungeons_helper): boolean, game_object | nil, game_object | nil
---@field public is_kikatal_near_cosmic_cast fun(self: dungeons_helper, energy_threshold: number): boolean, game_object | nil
---@field public is_kikatal_grasping_blood_exception fun(self: dungeons_helper): boolean, game_object | nil, game_object | nil
---@field public is_fixation_exception fun(self: dungeons_helper): boolean, game_object | nil
---@field public is_xalataths_bargain_ascendant_exception fun(self: dungeons_helper): boolean, table<game_object>
