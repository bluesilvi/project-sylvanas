
-- By Lemons @ Project Sylvanas 
-- Aurora Systems: Header

local plugin = {}
local plugin_data = require("plugin_data")

plugin["name"] = plugin_data.name
plugin["version"] = plugin_data.version
plugin["author"] = plugin_data.author
plugin["load"] = true

local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

return plugin
