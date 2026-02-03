
--- Waypoint Recorder - Test Plugin for Simple Movement
--- Records waypoints while walking, replays them using simple_movement
--- Uses the built-in menu system
---
--- NOTE: Flying mode is WORK IN PROGRESS and not available

local plugin = {}

-- Dependencies
local vec3 = require("common/geometry/vector_3")
local color = require("common/color")

---@type simple_movement
local movement = require("common/utility/simple_movement")

-- ============================================================================
-- PLUGIN STATE
-- ============================================================================

local PLUGIN_NAME = "Waypoint Recorder"
local DATA_FILE_GROUND = "waypoint_recorder_ground"

-- Recording state
local is_recording = false
local recorded_waypoints = {}
local last_record_pos = nil

-- Playback state
local is_playing = false

-- Saved paths
local saved_paths_ground = {}
local current_path_name = "default"

-- Button click flags
local btn_record_ground = false
local btn_stop_record = false
local btn_add_waypoint = false
local btn_play_ground = false
local btn_stop = false
local btn_clear_ground = false

-- ============================================================================
-- MENU CONFIG
-- ============================================================================

local config = {
    main_tree = core.menu.tree_node(),
    enabled = core.menu.checkbox(true, "wp_recorder_enabled"),
    loop_enabled = core.menu.checkbox(false, "wp_recorder_loop"),
    smooth_enabled = core.menu.checkbox(true, "wp_recorder_smooth"),
    use_look_at = core.menu.checkbox(true, "wp_recorder_use_look_at"),
    record_distance = core.menu.slider_int(1, 10, 3, "wp_recorder_distance"),

    -- Buttons
    btn_record_ground = core.menu.button("wp_btn_record_ground"),
    btn_stop_record = core.menu.button("wp_btn_stop_record"),
    btn_add_waypoint = core.menu.button("wp_btn_add_waypoint"),
    btn_play_ground = core.menu.button("wp_btn_play_ground"),
    btn_stop = core.menu.button("wp_btn_stop"),
    btn_clear_ground = core.menu.button("wp_btn_clear_ground"),

    -- Tree nodes
    record_tree = core.menu.tree_node(),
    playback_tree = core.menu.tree_node(),
    flying_tree = core.menu.tree_node(),
    settings_tree = core.menu.tree_node(),
}

-- ============================================================================
-- FILE I/O
-- ============================================================================

local function save_paths_to_file(paths, filename)
    local lines = {}
    table.insert(lines, "{")

    local first = true
    for name, path_data in pairs(paths) do
        if not first then
            table.insert(lines, ",")
        end
        first = false

        local wp_strs = {}
        for _, wp in ipairs(path_data.waypoints) do
            table.insert(wp_strs, string.format("{\"x\":%.2f,\"y\":%.2f,\"z\":%.2f}", wp.x, wp.y, wp.z))
        end

        local entry = string.format('"%s":{"waypoints":[%s]}', name, table.concat(wp_strs, ","))
        table.insert(lines, entry)
    end

    table.insert(lines, "}")
    local content = table.concat(lines, "\n")

    core.create_data_file(filename)
    core.write_data_file(filename, content)
end

local function load_paths_from_file(filename)
    local content = core.read_data_file(filename)
    local paths = {}

    if not content or content == "" then
        return paths
    end

    for name in content:gmatch('"([^"]+)":%s*{') do
        paths[name] = { waypoints = {} }
    end

    for name, waypoints_str in content:gmatch('"([^"]+)":%s*{"waypoints":%s*%[([^%]]+)%]}') do
        if paths[name] then
            for x, y, z in waypoints_str:gmatch('{"x":([%d%.%-]+),"y":([%d%.%-]+),"z":([%d%.%-]+)}') do

                -- notes: cba
                ---@diagnostic disable-next-line: param-type-mismatch
                table.insert(paths[name].waypoints, vec3.new(tonumber(x), tonumber(y), tonumber(z)))
            end
        end
    end

    return paths
end

-- ============================================================================
-- RECORDING FUNCTIONS
-- ============================================================================

local function start_recording()
    is_recording = true
    recorded_waypoints = {}
    last_record_pos = nil

    if is_playing then
        movement:stop()
        is_playing = false
    end

    core.log("[WaypointRecorder] Recording GROUND - walk around!")
end

local function stop_recording()
    is_recording = false

    if #recorded_waypoints > 0 then
        saved_paths_ground[current_path_name] = { waypoints = {} }
        for _, wp in ipairs(recorded_waypoints) do
            table.insert(saved_paths_ground[current_path_name].waypoints, vec3.new(wp.x, wp.y, wp.z))
        end
        save_paths_to_file(saved_paths_ground, DATA_FILE_GROUND)
        core.log(string.format("[WaypointRecorder] Saved %d ground waypoints", #recorded_waypoints))
    else
        core.log("[WaypointRecorder] No waypoints recorded")
    end
end

local function add_waypoint_manual()
    local player = core.object_manager.get_local_player()
    if not player then return end

    local pos = player:get_position()
    if not pos then return end

    if not is_recording then
        start_recording()
    end

    table.insert(recorded_waypoints, vec3.new(pos.x, pos.y, pos.z))
    last_record_pos = pos

    core.log(string.format("[WaypointRecorder] Waypoint %d: (%.1f, %.1f, %.1f)",
        #recorded_waypoints, pos.x, pos.y, pos.z))
end

local function update_recording()
    if not is_recording then return end

    local player = core.object_manager.get_local_player()
    if not player then return end

    local pos = player:get_position()
    if not pos then return end

    local record_distance = config.record_distance:get()

    if last_record_pos then
        local dist = pos:dist_to(last_record_pos)
        if dist >= record_distance then
            table.insert(recorded_waypoints, vec3.new(pos.x, pos.y, pos.z))
            last_record_pos = pos
        end
    else
        table.insert(recorded_waypoints, vec3.new(pos.x, pos.y, pos.z))
        last_record_pos = pos
    end
end

-- ============================================================================
-- PLAYBACK FUNCTIONS
-- ============================================================================

local function start_playback()
    local path_data = saved_paths_ground[current_path_name]

    if not path_data or #path_data.waypoints == 0 then
        core.log("[WaypointRecorder] No ground waypoints to play!")
        return
    end

    if is_recording then
        stop_recording()
    end

    local loop = config.loop_enabled:get_state()

    movement:set_debug(true)
    movement:set_smoothing_enabled(config.smooth_enabled:get_state())
    movement:set_use_look_at(config.use_look_at:get_state())

    movement:navigate(path_data.waypoints, loop, true)
    is_playing = true

    local system = config.use_look_at:get_state() and "look_at" or "turns"
    core.log(string.format("[WaypointRecorder] Playing %d ground waypoints (loop: %s, system: %s)",
        #path_data.waypoints, tostring(loop), system))
end

local function stop_playback()
    movement:stop()
    movement:clear_navigation()
    is_playing = false
    core.log("[WaypointRecorder] Stopped")
end

local function update_playback()
    if not is_playing then return end

    local reached = movement:process()

    if reached then
        local loop = config.loop_enabled:get_state()
        if loop then
            local path_data = saved_paths_ground[current_path_name]
            if path_data and #path_data.waypoints > 0 then
                core.log("[WaypointRecorder] Loop - restarting from waypoint 1")
                movement:navigate(path_data.waypoints, true, true)
            end
        else
            movement:clear_navigation()
            is_playing = false
            core.log("[WaypointRecorder] Playback complete!")
        end
    end
end

local function clear_waypoints()
    saved_paths_ground[current_path_name] = nil
    save_paths_to_file(saved_paths_ground, DATA_FILE_GROUND)

    if is_recording then
        recorded_waypoints = {}
    end

    movement:clear_navigation()
    core.log("[WaypointRecorder] Cleared ground waypoints")
end

-- ============================================================================
-- MENU RENDER
-- ============================================================================

local function render_menu()
    config.main_tree:render("Waypoint Recorder", function()

        config.enabled:render("Enable Plugin")

        if not config.enabled:get_state() then return end

        -- Status info
        local status = "Idle"
        if is_recording then
            status = "RECORDING GROUND (" .. #recorded_waypoints .. " waypoints)"
        elseif is_playing then
            local progress = movement:get_progress()
            local idx = movement:get_current_index()
            local total = movement:get_waypoint_count()
            local system = movement:is_using_look_at() and "look_at" or "turns"
            status = string.format("PLAYING %d%% (%d/%d) [%s]", progress, idx, total, system)
        end
        core.menu.header():render("Status: " .. status, color.white())

        -- Waypoint counts
        local ground_count = saved_paths_ground[current_path_name] and #saved_paths_ground[current_path_name].waypoints or 0
        core.menu.header():render(string.format("Saved waypoints: %d", ground_count), color.white())

        -- Recording section
        config.record_tree:render("Recording", function()
            if not is_recording then
                if config.btn_record_ground:render("Start Recording") then
                    btn_record_ground = true
                end
            else
                if config.btn_stop_record:render("Stop Recording") then
                    btn_stop_record = true
                end
            end

            if config.btn_add_waypoint:render("+ Add Waypoint Here") then
                btn_add_waypoint = true
            end

            config.record_distance:render("Auto-record Distance (yards)")
        end)

        -- Playback section
        config.playback_tree:render("Playback", function()
            if not is_playing then
                if config.btn_play_ground:render("Play Path") then
                    btn_play_ground = true
                end
            else
                if config.btn_stop:render("Stop Playback") then
                    btn_stop = true
                end
            end

            config.loop_enabled:render("Loop Path")
            config.use_look_at:render("Use Look At System")
            core.menu.header():render("^ Unchecked = use turn_left/turn_right", color.new(150, 150, 150, 255))
        end)

        -- Flying section (WIP)
        config.flying_tree:render("Flying (WIP)", function()
            core.menu.header():render("Flying is not available", color.new(255, 200, 50, 255))
            core.menu.header():render("Work in Progress", color.new(255, 200, 50, 255))
            core.menu.header():render("Legacy Flying: Not implemented", color.new(150, 150, 150, 255))
            core.menu.header():render("Dragonriding: Not supported", color.new(150, 150, 150, 255))
        end)

        -- Settings section
        config.settings_tree:render("Settings", function()
            config.smooth_enabled:render("Path Smoothing")

            if config.btn_clear_ground:render("Clear All Waypoints") then
                btn_clear_ground = true
            end
        end)

    end)
end

-- ============================================================================
-- PATH VISUALIZATION
-- ============================================================================

local function render_path()
    if not config.enabled:get_state() then return end

    local player = core.object_manager.get_local_player()
    if not player then return end

    local player_pos = player:get_position()
    if not player_pos then return end

    -- Draw recording waypoints (red)
    if is_recording and #recorded_waypoints > 0 then
        local line_color = color.new(255, 100, 100, 255)
        local point_color = color.new(255, 255, 0, 255)

        for i = 1, #recorded_waypoints - 1 do
            local p1 = recorded_waypoints[i]
            local p2 = recorded_waypoints[i + 1]
            if player_pos:dist_to(p1) < 100 or player_pos:dist_to(p2) < 100 then
                core.graphics.line_3d(p1, p2, line_color, 2.0)
            end
        end

        for i, wp in ipairs(recorded_waypoints) do
            if player_pos:dist_to(wp) < 50 then
                core.graphics.circle_3d(wp, 0.5, point_color, 8, 2)
            end
        end
        return
    end

    -- Draw saved ground waypoints (green)
    if saved_paths_ground[current_path_name] then
        local waypoints_to_draw = saved_paths_ground[current_path_name].waypoints
        if #waypoints_to_draw > 0 then
            local line_color = color.new(80, 255, 80, 200)
            for i = 1, #waypoints_to_draw - 1 do
                local p1 = waypoints_to_draw[i]
                local p2 = waypoints_to_draw[i + 1]
                if player_pos:dist_to(p1) < 100 or player_pos:dist_to(p2) < 100 then
                    core.graphics.line_3d(p1, p2, line_color, 2.0)
                end
            end
            for i, wp in ipairs(waypoints_to_draw) do
                if player_pos:dist_to(wp) < 50 then
                    core.graphics.circle_3d(wp, 0.4, line_color, 8, 2)
                end
            end
        end
    end

    -- Draw current target (cyan circle)
    if is_playing then
        local target = movement:get_target()
        if target then
            core.graphics.circle_3d(target, 1.0, color.new(0, 255, 255, 255), 16, 3)
        end
    end
end

-- ============================================================================
-- CALLBACKS
-- ============================================================================

local initialized = false

local function on_update()
    if not initialized then
        saved_paths_ground = load_paths_from_file(DATA_FILE_GROUND)
        movement:set_debug(true)
        initialized = true

        local ground_count = 0
        for _ in pairs(saved_paths_ground) do ground_count = ground_count + 1 end
        core.log(string.format("[WaypointRecorder] Loaded! Ground paths: %d", ground_count))
    end

    if not config.enabled:get_state() then return end

    -- Handle button clicks
    if btn_record_ground then
        btn_record_ground = false
        start_recording()
    end

    if btn_stop_record then
        btn_stop_record = false
        stop_recording()
    end

    if btn_add_waypoint then
        btn_add_waypoint = false
        add_waypoint_manual()
    end

    if btn_play_ground then
        btn_play_ground = false
        start_playback()
    end

    if btn_stop then
        btn_stop = false
        stop_playback()
    end

    if btn_clear_ground then
        btn_clear_ground = false
        clear_waypoints()
    end

    -- Update systems
    update_recording()
    update_playback()
end

local function on_render_menu()
    render_menu()
end

local function on_render()
    render_path()
end

-- ============================================================================
-- REGISTER
-- ============================================================================

core.register_on_update_callback(on_update)
core.register_on_render_menu_callback(on_render_menu)
core.register_on_render_callback(on_render)

