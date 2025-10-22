
-- Note:
-- Keep in mind this is an example the core already has fire mage loaded by default
-- So in order to try this code properly you should disable default mage fire plugin

local plugin = {}

plugin["name"] = "Placeholder Script"
plugin["version"] = "0.10"
plugin["author"] = "Author Name"
plugin["load"] = true

-- check if local player exists before loading the script (user is on loading screen / not ingame)
local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

---@type enums
local enums = require("common/enums")
local player_class = local_player:get_class()

-- in this case we do not want to load unless mage class

local is_valid_class = player_class == enums.class_id.MAGE

if not is_valid_class then
    plugin["load"] = false
    return plugin
end

-- in this case we do not want to load unless its a mage fire specialization

local player_spec_id = core.spell_book.get_specialization_id()
local fire_mage = enums.class_spec_id.get_spec_id_from_enum(enums.class_spec_id.spec_enum.FIRE_MAGE)

if player_spec_id ~= fire_mage then
    plugin["load"] = false
    return plugin
end

return plugin