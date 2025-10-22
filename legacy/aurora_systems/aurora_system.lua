
-- By Lemons @ Project Sylvanas 
-- Aurora Systems

---@type color
local color = require("common/color")

---@type vec3
local vec3 = require("common/geometry/vector_3")

local AuroraSystem = {}

-- Initialize menu elements
function AuroraSystem:init_menu()
    self.menu_elements = {
        main_tree = core.menu.tree_node(),
        enable = core.menu.checkbox(true, "enable_aurora"),

        -- Aurora Style
        style_tree = core.menu.tree_node(),
        radius = core.menu.slider_float(1.0, 5.0, 2.0, "aurora_radius"),
        points = core.menu.slider_int(20, 100, 60, "aurora_points"),
        height = core.menu.slider_float(0.1, 3.0, 1.0, "aurora_height"),
        rotation_speed = core.menu.slider_float(0.1, 5.0, 1.0, "rotation_speed"),

        -- Wave Settings
        wave_tree = core.menu.tree_node(),
        horizontal_folds = core.menu.slider_int(1, 12, 3, "horizontal_folds"),
        vertical_folds = core.menu.slider_int(0, 8, 2, "vertical_folds"),
        wave_intensity = core.menu.slider_float(0.0, 2.0, 0.5, "wave_intensity"),
        vertical_intensity = core.menu.slider_float(0.0, 2.0, 0.3, "vertical_intensity"),
        wave_speed = core.menu.slider_float(0.1, 5.0, 1.0, "wave_speed"),
        vertical_speed = core.menu.slider_float(0.1, 5.0, 0.8, "vertical_speed"),
        phase_shift = core.menu.slider_float(0.0, 2.0, 0.5, "phase_shift"),

        -- Colors
        color_tree = core.menu.tree_node(),
        primary_color = core.menu.colorpicker(color.new(64, 224, 208, 180), "primary_color"),
        secondary_color = core.menu.colorpicker(color.new(147, 112, 219, 180), "secondary_color"),
        gradient_speed = core.menu.slider_float(0.1, 5.0, 1.0, "gradient_speed"),
        use_rainbow = core.menu.checkbox(false, "use_rainbow"),
        rainbow_speed = core.menu.slider_float(0.1, 5.0, 1.0, "rainbow_speed"),
        vertical_color_shift = core.menu.checkbox(true, "vertical_color_shift"),
    }
end

-- Calculate aurora point position with wave effects
function AuroraSystem:get_aurora_point(center, radius, angle, height_factor, time)
    -- Horizontal waves
    local h_wave = math.sin(angle * self.menu_elements.horizontal_folds:get() + time * self.menu_elements.wave_speed:get())
    local wave_radius = radius + (h_wave * self.menu_elements.wave_intensity:get())

    -- Vertical waves
    local v_wave = math.sin(
        angle * self.menu_elements.vertical_folds:get() +
        time * self.menu_elements.vertical_speed:get() +
        height_factor * self.menu_elements.phase_shift:get() * math.pi
    )
    local height_offset = v_wave * self.menu_elements.vertical_intensity:get()

    return vec3.new(
        center.x + math.cos(angle) * wave_radius,
        center.y + math.sin(angle) * wave_radius,
        center.z + (height_factor * self.menu_elements.height:get()) + height_offset
    )
end

-- Calculate color for a point
function AuroraSystem:get_point_color(height_factor, time, point_ratio)
    if self.menu_elements.use_rainbow:get_state() then
        local rainbow_time = time * self.menu_elements.rainbow_speed:get()
        local color_ratio = point_ratio + rainbow_time
        if self.menu_elements.vertical_color_shift:get_state() then
            color_ratio = color_ratio + height_factor * 0.5
        end
        return color.get_rainbow_color(color_ratio)
    else
        local gradient_phase = (math.sin(time * self.menu_elements.gradient_speed:get()) + 1) / 2
        if self.menu_elements.vertical_color_shift:get_state() then
            gradient_phase = (gradient_phase + height_factor) % 1
        end
        return self.menu_elements.primary_color:get():blend(self.menu_elements.secondary_color:get(), gradient_phase)
    end
end

-- Render the aurora effect
function AuroraSystem:render()
    if not self.menu_elements.enable:get_state() then return end

    local player = core.object_manager.get_local_player()
    if not player then return end

    local position = player:get_position()
    local time = core.game_time() / 1000
    local radius = self.menu_elements.radius:get()
    local num_points = self.menu_elements.points:get()
    local rotation_offset = time * self.menu_elements.rotation_speed:get()

    -- Create vertical layers
    local layers = 8
    local points = {}

    -- Generate points for each layer
    for layer = 0, layers do
        points[layer] = {}
        local height_factor = layer / layers

        for i = 1, num_points do
            local angle = (i / num_points) * math.pi * 2 + rotation_offset
            points[layer][i] = self:get_aurora_point(position, radius, angle, height_factor, time)
        end
    end

    -- Draw horizontal connections
    for layer = 0, layers do
        local height_factor = layer / layers
        for i = 1, num_points do
            local next_i = (i % num_points) + 1
            local point_color = self:get_point_color(height_factor, time, i / num_points)
            core.graphics.line_3d(points[layer][i], points[layer][next_i], point_color, 2)
        end
    end

    -- Draw vertical connections
    for i = 1, num_points do
        for layer = 0, layers - 1 do
            local height_factor = layer / layers
            local point_color = self:get_point_color(height_factor, time, i / num_points)
            core.graphics.line_3d(points[layer][i], points[layer + 1][i], point_color, 2)
        end
    end
end

-- Render the menu
function AuroraSystem:render_menu()
    self.menu_elements.main_tree:render("Enhanced Player Aurora", function()
        self.menu_elements.enable:render("Enable Aurora Effect", "Toggle the aurora visual effect")

        self.menu_elements.style_tree:render("Aurora Style", function()
            self.menu_elements.radius:render("Base Radius", "Base size of the aurora effect")
            self.menu_elements.points:render("Detail Level", "Number of points in the aurora (higher = smoother)")
            self.menu_elements.height:render("Height", "Vertical height of the aurora")
            self.menu_elements.rotation_speed:render("Rotation Speed", "How fast the aurora rotates")
        end)

        self.menu_elements.wave_tree:render("Wave Settings", function()
            self.menu_elements.horizontal_folds:render("Horizontal Folds", "Number of horizontal wave patterns")
            self.menu_elements.vertical_folds:render("Vertical Folds", "Number of vertical wave patterns")
            self.menu_elements.wave_intensity:render("Horizontal \nWave Intensity", "How pronounced the horizontal waves are")
            self.menu_elements.vertical_intensity:render("Vertical \nWave Intensity", "How pronounced the vertical waves are")
            self.menu_elements.wave_speed:render("Horizontal \nWave Speed", "How fast the horizontal waves move")
            self.menu_elements.vertical_speed:render("Vertical \nWave Speed", "How fast the vertical waves move")
            self.menu_elements.phase_shift:render("Phase Shift", "Offset between horizontal and vertical waves")
        end)

        self.menu_elements.color_tree:render("Color Settings", function()
            self.menu_elements.use_rainbow:render("Rainbow Mode", "Cycle through colors automatically")
            self.menu_elements.vertical_color_shift:render("Vertical Color Shift", "Shift colors based on height")

            if not self.menu_elements.use_rainbow:get_state() then
                self.menu_elements.primary_color:render("Primary Color", "Main color of the aurora")
                self.menu_elements.secondary_color:render("Secondary Color", "Secondary color for gradient")
                self.menu_elements.gradient_speed:render("Gradient Speed", "How fast colors blend")
            else
                self.menu_elements.rainbow_speed:render("Rainbow Speed", "How fast colors change in rainbow mode")
            end
        end)
    end)
end

return AuroraSystem