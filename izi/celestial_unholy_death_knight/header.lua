local plugin = {}

plugin.name = "Unholy Death Knight"
plugin.version = "1.0.0"
plugin.author = "Voltz"
plugin.load = true

local local_player = core.object_manager:get_local_player()

if not local_player or not local_player:is_valid() then
    plugin.load = false
    return plugin
end

---@type enums
local enums = require("common/enums")
local player_class = local_player:get_class()

local is_valid_class = player_class == enums.class_id.DEATHKNIGHT

if not is_valid_class then
    plugin.load = false
    return plugin
end

local spec_id = enums.class_spec_id
local player_spec_id = local_player:get_specialization_id()

local is_valid_spec = player_spec_id == spec_id.get_spec_id_from_enum(spec_id.spec_enum.UNHOLY_DEATHKNIGHT)

if not is_valid_spec then
    plugin.load = false
    return plugin
end

return plugin
