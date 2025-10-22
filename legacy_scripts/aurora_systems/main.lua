
-- By Lemons @ Project Sylvanas 
-- Aurora Systems: Main

-- Import the systems
local AuroraSystem = require("aurora_system")

-- Initialize the systems
AuroraSystem:init_menu()

-- Register callbacks
core.register_on_render_callback(function()
    AuroraSystem:render()
end)

core.register_on_render_menu_callback(function()
    AuroraSystem:render_menu()
end)

core.log("Enhanced Player Aurora loaded successfully!")