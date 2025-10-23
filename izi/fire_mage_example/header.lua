--Setup our plugin info
local plugin = {}

plugin.name = "IZI Fire Mage Example"
plugin.version = "0.0.1"
plugin.author = "Voltz"
plugin.load = true

--Ensure the local player is valid, if not we should not load the plugin
local local_player = core.object_manager:get_local_player()

if not local_player or not local_player:is_valid() then
    plugin.load = false
    return plugin
end

--Import enums for class and spec IDs
local enums = require("common/enums")

--Get the local player's class
local player_class = local_player:get_class()

--Are we a mage?
local is_valid_class = player_class == enums.class_id.MAGE

--If we are not a mage then dont load the plugin
if not is_valid_class then
    plugin.load = false
    return plugin
end

--Get spec ID enum
local spec_id = enums.class_spec_id

--Get the local player's spec ID
local player_spec_id = local_player:get_specialization_id()

--Are we a Fire Mage?
local is_valid_spec = player_spec_id == spec_id.get_spec_id_from_enum(spec_id.spec_enum.FIRE_MAGE)

-- If we are not Fire Mage then dont load the plugin
if not is_valid_spec then
    plugin.load = false
    return plugin
end

return plugin
