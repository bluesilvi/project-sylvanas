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
local player_class = local_player:get_class()              --Get the local player's class
local is_valid_class = player_class == enums.class_id.MAGE --Are we a mage?

if not is_valid_class then                                 --If we are not a mage then dont load the plugin
    plugin.load = false
    return plugin
end

local spec_id = enums.class_spec_id                                                                --Get spec ID enum
local player_spec_id = local_player:get_specialization_id()                                        --Get the local player's spec ID
local is_valid_spec = player_spec_id == spec_id.get_spec_id_from_enum(spec_id.spec_enum.FIRE_MAGE) --Are we Fire Mage?

if not is_valid_spec then                                                                          -- If we are not Fire Mage then dont load the plugin
    plugin.load = false
    return plugin
end

return plugin
