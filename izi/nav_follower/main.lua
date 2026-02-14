
-- Nav Follower: follow a target, focus, or named player via navmesh

local vec2  = require("common/geometry/vector_2")
local color = require("common/color")
local izi   = require("common/izi_sdk")
local plugin_helper = require("common/utility/plugin_helper")

local nav
local function get_nav()
    if nav then return nav end

    -- ignore warning here
    ---@diagnostic disable-next-line: undefined-field
    if not _G.NavLib then return nil end
    nav = _G.NavLib.create({
        movement = { waypoint_tolerance = 2.0, smoothing = "chaikin", optimize = true, allow_partial = true, use_corridor_indoor = false },
    })
    nav:on("stuck", function() core.log_warning("[NavFollow] Stuck") end)
    nav:on("failed", function() core.log_error("[NavFollow] Path failed") end)
    return nav
end

local MODE_TARGET = 1
local MODE_FOCUS  = 2
local MODE_NAME   = 3

local menu = {
    tree       = core.menu.tree_node(),
    mode       = core.menu.combobox(1, "nav_follow_mode"),
    name_input = core.menu.text_input("nav_follow_name"),
    btn_start = core.menu.button("nav_follow_start"),
    btn_stop  = core.menu.button("nav_follow_stop"),
    btn_pause = core.menu.button("nav_follow_pause"),
}

local c_follow = color.new(100, 200, 255, 255)
local c_path   = color.cyan(150)
local c_ok     = color.green()
local c_warn   = color.new(255, 200, 0, 255)
local c_fail   = color.red()
local c_idle   = color.new(150, 150, 150, 255)

local active      = false
local paused      = false
local follow_obj  = nil
local last_path_t = 0
local last_scan_t = 0
local cached_name_obj = nil

local function me()     return core.object_manager.get_local_player() end
local function my_pos() local p = me(); return p and p:get_position() end

local function dist_to(obj)
    local m = my_pos()
    if not m or not obj then return 999 end
    return m:dist_to(obj:get_position())
end

-- resolve follow target based on current mode
local function resolve_target()
    local mode = menu.mode:get()
    local now = core.time()

    if mode == MODE_TARGET then
        local p = me()
        return p and p:get_target()

    elseif mode == MODE_FOCUS then
        return core.input.get_focus()

    elseif mode == MODE_NAME then
        -- scan object manager every 2s
        if cached_name_obj and cached_name_obj:is_valid() and not cached_name_obj:is_dead() then
            if now - last_scan_t < 2.0 then return cached_name_obj end
        end

        last_scan_t = now
        local wanted = menu.name_input:get_text()
        if not wanted or wanted == "" then return nil end

        local actors = core.object_manager.get_all_objects()
        for _, obj in ipairs(actors) do
            if obj:get_name() == wanted and not obj:is_dead() then
                cached_name_obj = obj
                return obj
            end
        end
        cached_name_obj = nil
        return nil
    end

    return nil
end

local function start_follow()
    if not get_nav() then return end
    active, paused = true, false
    follow_obj = nil
    last_path_t = 0
    core.log("[NavFollow] Started")
end

local function stop_follow()
    local n = get_nav()
    if n then n:stop() end
    active, paused = false, false
    follow_obj = nil
    cached_name_obj = nil
    core.log("[NavFollow] Stopped")
end

local function pause_follow()
    if not active then return end
    paused = not paused
    if paused then
        local n = get_nav()
        if n then n:stop() end
    end
    core.log("[NavFollow] " .. (paused and "Paused" or "Resumed"))
end

izi.on_key_release(0x04, function()
    if active then stop_follow() end
end)

core.register_on_update_callback(function()
    local n = get_nav()
    if not n then return end
    if n then n:update() end
    if not active or paused then return end

    local p = me()
    if not p or p:is_dead() or p:is_ghost() then return end

    local target = resolve_target()
    if not target or not target:is_valid() or target:is_dead() then
        follow_obj = nil
        return
    end

    follow_obj = target
    local d = dist_to(target)
    local now = core.time()

    -- close = refresh faster, far = slower
    local interval = d < 30 and 0.2 or 1.0

    -- close enough, no need to path
    if d < 3.0 then
        n:stop()
        last_path_t = now
        return
    end

    if now - last_path_t < interval then return end
    last_path_t = now

    local target_pos = target:get_position()
    n:move_to(target_pos, function(ok, reason)
        -- just let it re-path next tick, don't stop following
        if not ok then
            core.log_warning("[NavFollow] Path failed: " .. tostring(reason))
        end
    end)
end)

core.register_on_render_callback(function()
    local p = me()
    if not p or p:is_dead() or p:is_ghost() then return end
    if not active then return end

    local n = get_nav()
    local pos = p:get_position()

    if follow_obj and follow_obj:is_valid() then
        local tpos = follow_obj:get_position()
        core.graphics.circle_3d(tpos, 1.0, c_follow, 2.0, 2.0)
    end

    if n then
        local path = n:get_current_path()
        if path and #path > 0 then
            for i = 1, #path do
                if i % 12 == 1 or i == #path then
                    core.graphics.circle_3d(path[i], 0.5, c_path, 10, 1.5)
                end
                if i < #path then
                    core.graphics.line_3d(path[i], path[i+1], color.white(100), 2, 1.5, true)
                end
            end
        end
    end

    -- banner
    local scr = core.graphics.get_screen_size()
    local cx = scr.x * 0.5
    local cy = scr.y * 0.25

    local name = follow_obj and follow_obj:is_valid() and follow_obj:get_name() or "Searching..."
    local d_str = follow_obj and string.format("%.0f yd", dist_to(follow_obj)) or "?"
    local status = paused and "FOLLOW: PAUSED" or "FOLLOWING: " .. name
    local banner_text = status .. " \n" .. d_str .. " | MMB TO STOP"
    local bc = paused and c_warn or c_follow

    local tw = core.graphics.get_text_width(banner_text, 9, 3)

    plugin_helper:draw_text_message(banner_text, bc, color.new(0, 0, 0, 150),
        vec2.new(cx - tw, cy), vec2.new(200, 36),
        false, true, "nav_fol_banner", nil, true, 3)
end)

core.register_on_render_menu_callback(function()
    menu.tree:render("Nav Follower", function()
        menu.mode:render("Follow Mode", {"Target", "Focus", "Custom Name"})

        if menu.mode:get() == MODE_NAME then
            menu.name_input:render("Player Name")
        end

        if not active then
            if menu.btn_start:render("Start") then start_follow() end
        else
            if menu.btn_stop:render("Stop") then stop_follow() end
            if menu.btn_pause:render(paused and "Resume" or "Pause") then pause_follow() end
        end

        -- status
        if active then
            local name = follow_obj and follow_obj:is_valid() and follow_obj:get_name() or "---"
            local d = follow_obj and string.format("%.0f yd", dist_to(follow_obj)) or "?"
            core.menu.header():render(string.format("%s: %s (%s)", paused and "Paused" or "Following", name, d),
                paused and c_warn or c_follow)
        else
            core.menu.header():render("Idle", c_idle)
        end

        local n = get_nav()
        if n then
            local ok = n:is_server_available()
            core.menu.header():render("NavBuddy: " .. (ok and "Connected" or "Disconnected"), ok and c_ok or c_fail)
        else
            core.menu.header():render("NavLib: not loaded", c_fail)
        end
    end)
end)
