
-- Example:
-- ---@type combat_forecast
-- local x = require("common/modules/combat_forecast")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class forecast_lenghts
---@field public DISABLED number
---@field public VERY_SHORT number
---@field public SHORT number
---@field public MEDIUM number
---@field public LONG number

---@class combat_forecast
--- Enum for forecast modes.
---@field public enum forecast_lenghts
--- Gets the forecast data.
---@field public get_forecast fun(self: nil): any
--- Gets the forecast data for a single unit.
---@field public get_forecast_single fun(self: nil, unit: game_object, include_pvp?: boolean): any
--- Gets the minimum combat length for a given forecast mode, plugin, and spell.
---@field public get_min_combat_length fun(self: nil, forecast_mode: any, plugin_name: string, spell_name: string): number
--- Validates the forecast logic based on the minimum combat length and unit.
---@field public is_valid_forecast_logic fun(self: nil, min_combat_length: number, unit?: game_object, include_pvp?: boolean): boolean
