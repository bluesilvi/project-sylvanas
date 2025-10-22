
---@class unit_manager
---@field public get_cache_unit_list_raw fun(self: unit_manager): table
---@field public get_cache_unit_list fun(self: unit_manager): table
---@field public get_enemies_around_point fun(self: unit_manager, point: table, range: number, players_only: boolean, include_dead: boolean): table
---@field public get_allies_around_point fun(self: unit_manager,point: table, range: number, players_only: boolean, party_only: boolean, include_dead: boolean): table
---@field public process fun(self: unit_manager): nil
