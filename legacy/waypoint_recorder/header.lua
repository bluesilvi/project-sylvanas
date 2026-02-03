local plugin = {}

plugin["name"] = "Waypoint Recorder"
plugin["version"] = "1.01"
plugin["author"] = "Silvi"
plugin["load"] = true

local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

return plugin