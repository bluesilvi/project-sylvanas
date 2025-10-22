
-- Blue Silvi Spell Prediction Playground Plugin: Main

local code_name = "spell_prediction_playground_"

local plugin_data = require("plugin_data")

local source_options = { "Player", "Cursor" }
local source_options_enum = 
{
    PLAYER = 1,
    CURSOR = 2,
}

local destination_options = { "UI Target", "Cursor Position", "Local Direction Anchor" }
local destination_options_enum = 
{
    UI_TARGET = 1,
    CURSOR_POSITION = 2,
    DIRECTION_ANCHOR = 3,
}

local type_options = { "Accuracy", "Most Hits" }
local type_options_enum =
{
    ACCURACY = 1,
    MOST_HITS = 2,
}

local geometry_options = { "Circle", "Rectangle", "Cone" }
local geometry_options_enum =
{
    CIRCLE = 1,
    RECTANGLE = 2,
    CONE = 3,
}

local menu_elements = {
    submenu = core.menu.tree_node(),
    global_enable = core.menu.checkbox(false, code_name .. "global_enable"),

    prediction_spell_data_node = core.menu.tree_node(),
    source_combobox = core.menu.combobox(1, code_name .. "source_combobox"),
    destination_combobox = core.menu.combobox(1, code_name .. "destination_combobox"),

    type_combobox = core.menu.combobox(type_options_enum.ACCURACY, code_name .. "type_combobox"),
    geometry_combobox = core.menu.combobox(geometry_options_enum.CIRCLE, code_name .. "geometry_combobox"),

    radius_slider = core.menu.slider_float(0.20, 10.0, 3.0, code_name .. "radius_slider"),
    range_slider = core.menu.slider_float(1.0, 30.0, 10.0, code_name .. "range_slider"),
    angle_slider = core.menu.slider_float(10.0, 180.0, 45.0, code_name .. "angle_slider"),
    cast_time_slider = core.menu.slider_float(0.0, 3.0, 0.0, code_name .. "cast_time_slider"),
    projectile_speed_slider = core.menu.slider_int(0, 100, 0, code_name .. "projectile_speed_slider"),
    override_hit_time_slider = core.menu.slider_float(0.0, 4.0, 0.0, code_name .. "override_hit_time_slider"),
    override_hitbox_min_slider = core.menu.slider_float(0.0, 1.0, 0.0, code_name .. "override_hitbox_min_slider"),
    cache_slider = core.menu.slider_float(0.0, 0.5, 0.0, code_name .. "cache_slider"),

    draw_hits_amount = core.menu.checkbox(true, code_name .. "draw_hits_amount"),
    draw_hits_positions = core.menu.checkbox(true, code_name .. "draw_hits_positions"),
}

local function menu()
    menu_elements.submenu:render(plugin_data.title, function()
        menu_elements.global_enable:render("Enable")

        if menu_elements.global_enable:get_state() then
            menu_elements.prediction_spell_data_node:render("Spell Data", function()
                menu_elements.source_combobox:render("Source", source_options)
                menu_elements.destination_combobox:render("Destination", destination_options)

                menu_elements.type_combobox:render("Type", type_options)
                menu_elements.geometry_combobox:render("Geometry", geometry_options)

                menu_elements.radius_slider:render("Radius")
                menu_elements.range_slider:render("Range")
                menu_elements.angle_slider:render("Angle")
                menu_elements.cast_time_slider:render("Cast Time")
                menu_elements.projectile_speed_slider:render("Projectile Speed")
                menu_elements.override_hit_time_slider:render("Override Hit Time")
                menu_elements.override_hitbox_min_slider:render("Override Hitbox Min")
            end)

            menu_elements.draw_hits_amount:render("Draw Hits Amount")
            menu_elements.draw_hits_positions:render("Draw Hits Positions")
            menu_elements.cache_slider:render("Cache Slider")
        end
    end)
end

---@type color
local color = require("common/color")

---@type vec3
local vec3 = require("common/geometry/vector_3")

---@type spell_prediction
local spell_prediction = require("common/modules/spell_prediction")

---@return vec3
local function get_source_position()
    local local_player = core.object_manager.get_local_player()
    if not local_player then
        return vec3.new(0,0,0)
    end

    local source_option = menu_elements.source_combobox:get()
    if source_option == source_options_enum.PLAYER then
        return local_player:get_position()
    end

    return core.graphics.get_cursor_world_position()
end

local cone = require("common/geometry/cone")
local circle = require("common/geometry/circle")
local rectangle = require("common/geometry/rectangle")

local cached_results = {}
local cache_duration = 0.0

local function get_cached_result(key)
    local current_time = core.time()
    if cached_results[key] and (current_time - cached_results[key].timestamp < cache_duration) then
        return cached_results[key].result
    end
    return nil
end

local function set_cached_result(key, result)
    cached_results[key] = { result = result, timestamp = core.time() }
end

local function draw_prediction()
    if not menu_elements.global_enable:get_state() then
       return
    end

    local local_player = core.object_manager.get_local_player()
    if not local_player or not local_player:is_valid() then
        return
    end

    local placeholder_spell_id = 12345
    local source_position = get_source_position()
    local prediction_spell_data = spell_prediction:new_spell_data(
        placeholder_spell_id,                           -- spell_id
        menu_elements.range_slider:get(),               -- range                        
        menu_elements.radius_slider:get(),              -- radius
        menu_elements.cast_time_slider:get(),           -- cast_time
        menu_elements.projectile_speed_slider:get(),    -- projectile_speed
        menu_elements.type_combobox:get(),              -- prediction_type
        menu_elements.geometry_combobox:get(),          -- geometry_type
        source_position                                 -- source_position
    )

    prediction_spell_data.angle = menu_elements.angle_slider:get()
    prediction_spell_data.hitbox_min = menu_elements.override_hitbox_min_slider:get()

    prediction_spell_data.intersection_factor = 0.0
    -- prediction_spell_data.exception_player_included = true
    if menu_elements.override_hit_time_slider:get() > 0 then
        prediction_spell_data.time_to_hit_override = menu_elements.override_hit_time_slider:get()
    end

    local world_cursor_position = core.graphics.get_cursor_world_position()
    local prediction_key = "cast_position_tmp"
    local prediction_result = get_cached_result(prediction_key)

    if not prediction_result then
        prediction_result = spell_prediction:get_cast_position_(world_cursor_position, prediction_spell_data)
        set_cached_result(prediction_key, prediction_result)
    end

    local player_position = local_player:get_position()
    local destination_option = menu_elements.destination_combobox:get()
    if destination_option == destination_options_enum.UI_TARGET then

        ---@type game_object
        local target = local_player:get_target()
        if not target or not target:is_valid() then
            return
        end

        cache_duration = menu_elements.cache_slider:get()
        prediction_key = "cast_position_target"
        prediction_result = get_cached_result(prediction_key)

        if not prediction_result then
            prediction_result = spell_prediction:get_cast_position(target, prediction_spell_data)
            set_cached_result(prediction_key, prediction_result)
        end
    else
        cache_duration = menu_elements.cache_slider:get()
    end

    if destination_option == destination_options_enum.DIRECTION_ANCHOR then

        local player_direction = local_player:get_direction()
        local player_velocity = player_position + player_direction
        prediction_key = "cast_position_direction"
        prediction_result = get_cached_result(prediction_key)

        if not prediction_result then
            prediction_result = spell_prediction:get_cast_position_(player_position:get_extended(player_velocity, prediction_spell_data.max_range), prediction_spell_data)
            set_cached_result(prediction_key, prediction_result)
        end
    end

    if menu_elements.draw_hits_amount:get_state() then
        local average_position = (prediction_result.cast_position + player_position) * 0.5
        local screen_position = core.graphics.w2s(average_position)
        if screen_position then
            screen_position.y = screen_position.y - 25.0
            core.graphics.text_2d("Hits: " .. prediction_result.amount_of_hits, screen_position, 20, color.red(), true)
        end
    end

    if menu_elements.draw_hits_positions:get_state() then
        for _, hit in ipairs(prediction_result.hit_list) do
			core.graphics.circle_3d(hit.center_position, 0.30, color.blue(140), 8.0, 1.50)
        end
    end

    if prediction_spell_data.geometry_type == spell_prediction.geometry_type.CIRCLE then
        local my_circle = circle:create(prediction_result.cast_position, prediction_spell_data.radius)
        my_circle:draw()
    elseif prediction_spell_data.geometry_type == spell_prediction.geometry_type.RECTANGLE then
        local my_rectangle = rectangle:create(source_position, prediction_result.cast_position, prediction_spell_data.radius, prediction_spell_data.max_range)
        my_rectangle:draw()
    elseif prediction_spell_data.geometry_type == spell_prediction.geometry_type.CONE then
        local my_cone = cone:create(source_position, prediction_result.cast_position, prediction_spell_data.radius, prediction_spell_data.angle)
        my_cone:draw()
    end
end

core.register_on_render_menu_callback(menu)
core.register_on_render_callback(draw_prediction)