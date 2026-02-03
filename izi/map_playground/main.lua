
--------------------------------------------------------------------------------
-- map_playground/main.lua
--
-- Example plugin demonstrating coords via izi SDK.
-- Left-click on minimap: Add a 3D marker
-- Right-click on minimap: Remove nearest marker
-- Middle-click: Clear all markers
--------------------------------------------------------------------------------

local vec2 = require("common/geometry/vector_2")
local vec3 = require("common/geometry/vector_3")
local color = require("common/color")
local izi = require("common/izi_sdk")

-- Marker storage
local markers = {}

-- Configuration
local CONFIG = {
    marker_radius = 1.5,
    marker_thickness = 2.0,
    marker_fade = 2.5,
    marker_color = color.green(),
    line_color = color.cyan(),
    remove_threshold = 8.0,
}

-- Key codes
local VK_LBUTTON = 0x01
local VK_RBUTTON = 0x02
local VK_MBUTTON = 0x04

--------------------------------------------------------------------------------
-- Marker Functions
--------------------------------------------------------------------------------

local function add_marker(world_pos)
    markers[#markers + 1] = world_pos
    core.log("[map_playground] Marker added: (" ..
        string.format("%.1f", world_pos.x) .. ", " ..
        string.format("%.1f", world_pos.y) .. ", " ..
        string.format("%.1f", world_pos.z) .. ")")
end

local function find_nearest_marker(world_pos)
    local nearest_idx = nil
    local nearest_dist = CONFIG.remove_threshold * CONFIG.remove_threshold

    for i, marker in ipairs(markers) do
        local dist = marker:squared_dist_to_ignore_z(world_pos)
        if dist < nearest_dist then
            nearest_dist = dist
            nearest_idx = i
        end
    end

    return nearest_idx
end

local function remove_marker(world_pos)
    local idx = find_nearest_marker(world_pos)
    if idx then
        local removed = markers[idx]
        table.remove(markers, idx)
        core.log("[map_playground] Marker removed: (" ..
            string.format("%.1f", removed.x) .. ", " ..
            string.format("%.1f", removed.y) .. ")")
        return true
    end
    return false
end

local function clear_markers()
    local count = #markers
    markers = {}
    if count > 0 then
        core.log("[map_playground] Cleared " .. count .. " markers")
    end
end

--------------------------------------------------------------------------------
-- Click Handlers (using izi.on_key_release)
--------------------------------------------------------------------------------

local function handle_left_click()
    if core.graphics.is_menu_open() then return end
    if not core.game_ui.is_map_open() then return end

    -- One-liner via izi SDK!
    local world_pos = izi.get_cursor_world_pos()
    if world_pos then
        add_marker(world_pos)
    end
end

local function handle_right_click()
    if core.graphics.is_menu_open() then return end
    if not core.game_ui.is_map_open() then return end

    local world_pos = izi.get_cursor_world_pos()
    if world_pos then
        remove_marker(world_pos)
    end
end

local function handle_middle_click()
    if core.graphics.is_menu_open() then return end
    if not core.game_ui.is_map_open() then return end
    clear_markers()
end

-- Register key release callbacks
izi.on_key_release(VK_LBUTTON, handle_left_click)
izi.on_key_release(VK_RBUTTON, handle_right_click)
izi.on_key_release(VK_MBUTTON, handle_middle_click)

--------------------------------------------------------------------------------
-- Render
--------------------------------------------------------------------------------

local function on_render()
    local player = core.object_manager.get_local_player()
    if not player then return end

    local player_pos = player:get_position()

    -- Draw all markers
    for _, marker in ipairs(markers) do
        core.graphics.circle_3d(marker, CONFIG.marker_radius, CONFIG.marker_color, CONFIG.marker_thickness, CONFIG.marker_fade)
        core.graphics.line_3d(player_pos, marker, CONFIG.line_color, 3, 1.5, true)
    end

    -- HUD
    if #markers > 0 then
        local hud_text = "Markers: " .. #markers .. " | MMB to clear"
        core.graphics.text_2d(hud_text, vec2.new(20, 20), 16, CONFIG.marker_color, false)
    end
end

core.register_on_render_callback(on_render)

core.log("[map_playground] Loaded! LMB=Add, RMB=Remove, MMB=Clear")
