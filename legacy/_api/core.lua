
---@class core
_G.core = {}

--- Log a message to the console.
---@param message string The message to log.
function core.log(message) end

--- Log a message to log files.
---@param message string The message to log to files.
function core.log_file(message) end

--- Log a warning message to the console.
---@param message string The warning message to log.
function core.log_warning(message) end

--- Log an error message to the console.
---@param message string The error message to log.
function core.log_error(message) end

--- Register a function to be called before each tick.
---@param callback function The function to register as a pre-tick callback.
function core.register_on_pre_tick_callback(callback) end

--- Register a function to be called before each tick.
---@param callback function The function to register as a pre-tick callback.
function core.register_on_render_window_callback(callback) end

--- Register a function to be called during the update phase.
---@param callback function The function to register as an update callback.
function core.register_on_update_callback(callback) end

--- Register a function to be called during the rendering phase.
---@param callback function The function to register as a render callback.
function core.register_on_render_callback(callback) end

--- Register a function to be called during the rendering of menus.
---@param callback function The function to register as a render menu callback.
function core.register_on_render_menu_callback(callback) end

--- Register a function to be called to send control_panel data to core
---@param callback function The function to register as a control_panel callback
function core.register_on_render_control_panel_callback(callback) end

--- Register a function that triggers every time game registers a legit cast attempt
---@param callback function The function to register as a legit cast callback
function core.register_on_legit_spell_cast_callback(callback) end

--- Register a function that triggers every time game registers an spell cast
---@param callback function The function to register as an spell cast callback
function core.register_on_spell_cast_callback(callback) end

--- Get the current ping.
---@return number The current ping.
function core.get_ping()
    return 0
end

--- Get the current time in milliseconds since the injection time.
---@return number The current time in milliseconds.
function core.time()
    return 0
end

--- Useful for profiling
---@return number
function core.cpu_ticks()
    return 0
end

--- Useful for profiling
---@return number
function core.cpu_ticks_per_second()
    return 0
end

--- Get the current game time in milliseconds since the start of the game.
---@return number The current game time in milliseconds.
function core.game_time()
    return 0
end

--- Get the time in seconds since the last frame.
---@return number The time in seconds since the last frame.
function core.delta_time()
    return 0
end

--- Get the screen position of cursor.
---@return vec2 The screen position of cursor.
function core.get_cursor_position()
    return {}
end

--- Get the id of the current localplayer map.
---@return number The id of the current localplayer map.
function core.get_map_id()
    return 0
end

---@return number
function core.get_instance_id()
    return 0
end

---@return number
function core.get_difficulty_id()
    return 0
end

---@return number
function core.get_keystone_level()
    return 0
end

---@return string
function core.get_instance_name()
    return ""
end

---@return string
function core.get_difficulty_name()
    return ""
end

--- Get the name of the current localplayer map.
---@return string The name of the current localplayer map.
function core.get_map_name()
    return ""
end

---@return boolean
function core.is_debug()
    return false
end

---@return number
function core.get_user_role_flags()
    return 0
end

---@return number
function core.get_user_flags()
    return 0
end

---@return string
---@param text string
function core.read_file(text)
    return ""
end

---@return string
function core.get_account_name()
    return ""
end

---@return number
---@param pos vec3
function core.get_height_for_position(pos)
    return 0
end

---@return nil
function core.disable_drawings()
    return nil
end

---@return nil
function core.enable_drawings()
    return nil
end

---@class inventory
core.inventory = {}

--- -2 for the keyring
--- -4 for the tokens bag
--- 0 = backpack, 1 to 4 for the bags on the character
--- While bank is opened -1 for the bank content, 5 to 11 for bank bags (numbered left to right, was 5-10 prior to tbc expansion, 2.0 game version)
---@param bag_id integer BagId https://wowwiki-archive.fandom.com/wiki/BagId
---@return table<item_slot_info>
function core.inventory.get_items_in_bag(bag_id)
    return {}
end

---@class input
core.input = {}

--- Casts a spell on a specific target game object.
---@param spell_id integer The ID of the spell to cast.
---@param target game_object The target game object on which the spell will be cast.
---@return boolean Indicates whether the spell was successfully cast on the target.
function core.input.cast_target_spell(spell_id, target)
    return false
end

--- Casts a spell on a vec3 position
---@param spell_id integer The ID of the spell to cast.
---@param position vec3 the position where you want to cast the spell.
---@return boolean Indicates whether the spell was successfully cast on the position.
function core.input.cast_position_spell(spell_id, position)
    return false
end

--- Use a self cast item
---@param item_id integer The ID of the item to use.
---@return boolean Indicates whether the spell was successfully usage of the item
function core.input.use_item(item_id)
    return false
end

---@param target game_object
---@param item_id integer The ID of the item to use.
---@return boolean Indicates whether the spell was successfully usage of the item
function core.input.use_item_target(item_id, target)
    return false
end

---@param position vec3
---@param item_id integer The ID of the item to use.
---@return boolean Indicates whether the spell was successfully usage of the item
function core.input.use_item_position(item_id, position)
    return false
end

--- Set the local player target
---@param unit game_object The game_object to set as target
---@return boolean Return true on successfully targetting the desired unit
function core.input.set_target(unit)
    return false
end

--- Set the local player focus
---@param unit game_object The game_object to set as focus
---@return boolean Return true on successfully focusing the desired unit
function core.input.set_focus(unit)
    return false
end

--- Get the local player focus
---@return table Return the game_object focus, can be nil
function core.input.get_focus()
    return {};
end

--- Checks if the key is pressed
--- @param key integer The key to check if is pressed or not
--- @return boolean Returns true if the passed key is being currently pressed. Check https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
function core.input.is_key_pressed(key)
    return false;
end

--- @return nil
--- Starts local rotation to right side
function core.input.turn_right_start()
    return nil
end

--- @return nil
--- Stops local rotation to right side
function core.input.turn_right_stop()
    return nil
end

--- @return nil
--- Starts local rotation to left side
function core.input.turn_left_start()
    return nil
end

--- @return nil
--- Stops local rotation to left side
function core.input.turn_left_stop()
    return nil
end

--- @return nil
--- Starts local strafe to right
function core.input.strafe_right_start()
    return nil
end

--- @return nil
--- Stops local strafe to right
function core.input.strafe_right_stop()
    return nil
end

--- @return nil
--- Starts local strafe to left
function core.input.strafe_left_start()
    return nil
end

--- @return nil
--- Stops local strafe to left
function core.input.strafe_left_stop()
    return nil
end

--- @return nil
--- Starts local forward
function core.input.move_forward_start()
    return nil
end

--- @return nil
--- Stops local forward
function core.input.move_forward_stop()
    return nil
end

--- @return nil
--- Starts local backward
function core.input.move_backward_start()
    return nil
end

--- @return nil
--- Stops local backward
function core.input.move_backward_stop()
    return nil
end

--- @return nil
function core.input.cancel_spells()
    return nil
end

--- @return nil
function core.input.enable_movement()
    return nil
end

--- @return nil
function core.input.disable_movement()
    return nil
end

--- @return nil
--- @param object game_object
function core.input.set_control_object(object)
    return nil
end

--- @return game_object
function core.input.get_control_object(object)
    return object
end

--- @return nil
--- Faces to vec3
--- @param point vec3
function core.input.look_at(point)
    return nil
end

--- @return nil
function core.input.stop_attack()
    return nil
end

---@class object_manager
core.object_manager = {}

--- Retrieves the local player game object.
---@return game_object
function core.object_manager.get_local_player()
    return {}
end

--- Retrieves all game objects.
---@return game_object[]
function core.object_manager.get_all_objects()
    return {}
end

-- Retrieves the player for the given arena frame index, nil means we are not in arena
--- @param index integer
--- @return game_object | nil
function core.object_manager.get_arena_target(index)
    return {}
end

--- Retrieves all visible game objects.
---@return game_object[]
function core.object_manager.get_visible_objects()
    return {}
end

--- Retrieves a list of game objects with all the arena frames.
---@return game_object
function core.object_manager.get_arena_frames()
    return {}
end

--- Retrieves mouse_over object
---@return game_object
function core.object_manager.get_mouse_over_object()
    return {}
end

---@class spell_book
core.spell_book = {}

--- Retrieves the local_player specialization_id
---@return number The local_player specialization_id
function core.spell_book.get_specialization_id()
    return 0
end

--- Retrieves the global cooldown duration in seconds.
---@return number The global cooldown duration in seconds.
function core.spell_book.get_global_cooldown()
    return 0
end

--- Retrieves the cooldown duration of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return number The cooldown duration of the specified spell in seconds.
function core.spell_book.get_spell_cooldown(spell_id)
    return 0
end

--- Retrieves the amount of current charges of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return integer The amount of current stacks of the specified spell.
function core.spell_book.get_spell_charge(spell_id)
    return 0
end

--- Retrieves the amount of max charges of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return integer The amount of max stacks of the specified spell.
function core.spell_book.get_spell_charge_max(spell_id)
    return 0
end

--- Retrieves the name of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return string The name of the specified spell.
function core.spell_book.get_spell_name(spell_id)
    return ""
end

--- Retrieves the whole tooltip text of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return string The tooltip text of the specified spell.
function core.spell_book.get_spell_description(spell_id)
    return ""
end

--- Retrieves the whole tooltip text of the specified buff.
---@param buff_ptr buff
---@return string The tooltip text of the specified buff.
function core.spell_book.get_buff_description(buff_ptr)
    return ""
end

--- Retrieves a table containing all spells and their corresponding IDs.
---@return table<number>
function core.spell_book.get_spells()
    return {}
end

--- Checks if the specified spell identified by its ID is owned by the localplayer.
---@param spell_id integer The ID of the spell.
---@return boolean Returns true if the specified spell is equipped, otherwise returns false.
function core.spell_book.has_spell(spell_id)
    return false
end

--- Checks if the specified spell identified by its ID is learned by the localplayer.
---@param spell_id integer The ID of the spell.
---@return boolean Returns true if the specified spell is learned, otherwise returns false.
function core.spell_book.is_spell_learned(spell_id)
    return false
end

---@param n integer
---@param flag integer
---@param spell_id integer The ID of the spell.
---@return boolean Returns true if the specified spell has certain attribute.
function core.spell_book.spell_has_attribute(spell_id, n, flag)
    return false
end

--- Returns the spell_id from the talent_id.
---@param talent_id integer The ID of the talent.
---@return number Returns the spell_id from the talent_id.
function core.spell_book.get_talent_spell_id(talent_id)
    return 0
end

--- Returns the name from the talent_id.
---@param talent_id integer The ID of the talent.
---@return string Returns the name from the talent_id.
function core.spell_book.get_talent_name(talent_id)
    return ""
end

--- Checks if the specified spell is melee type.
---@param spell_id integer The ID of the spell.
---@return boolean Returns true if the specified spell is melee type.
function core.spell_book.is_melee_spell(spell_id)
    return false
end

--- Checks if the specified spell is an skillshot.
---@param spell_id integer The ID of the spell.
---@return boolean Returns true if the specified spell is skillshot.
function core.spell_book.is_spell_position_cast(spell_id)
    return false
end

--- Checks if the cursor is currently busy with an skillshot.
---@return boolean Returns true if the cursor is currently busy with an skillshot.
function core.spell_book.cursor_has_spell()
    return false
end

---@class spell_costs
---@field public min_cost number
---@field public cost number
---@field public cost_per_sec number
---@field public cost_type number
---@field public required_buff_id number

--- Returns spell_costs structure
---@param spell_id integer The ID of the spell.
---@return table<spell_costs>
function core.spell_book.get_spell_costs(spell_id)
    return {}
end

---@class range_data
---@field public min number
---@field public max number

--- Retrieves the range data of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return range_data A table containing the minimum and maximum range of the specified spell.
function core.spell_book.get_spell_range_data(spell_id)
    return {}
end

--- Retrieves the minimum range of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return number The minimum range of the specified spell.
function core.spell_book.get_spell_min_range(spell_id)
    return 0
end

--- Retrieves the maximum range of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return number The maximum range of the specified spell.
function core.spell_book.get_spell_max_range(spell_id)
    return 0
end

--- Retrieves the school flag of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return schools_flag The spell school flag.
function core.spell_book.get_spell_school(spell_id)

    ---@type schools_flag
    return nil
end

--- Retrieves the cast time of the specified spell identified by its ID.
---@param spell_id integer The ID of the spell.
---@return number The cast time in seconds.
function core.spell_book.get_spell_cast_time(spell_id)
    return 0
end

--- Note: This Function is deprecated
--- Alternative: Common Utility Spell Helper
--- Retrieves the damage value of the spell_id.
---@param spell_id integer The ID of the spell.
---@return number The damage value of the spell.
function core.spell_book.get_spell_damage(spell_id)
    return 0
end

---@class graphics
core.graphics = {}

--- Adds a notification to the display.
--- @param unique_id string UNIQUE identifier for the notification.
--- @param label string The title or heading for the notification.
--- @param message string The main content of the notification.
--- @param duration_ms integer The duration in seconds that the notification should be displayed.
--- @param color color The color of the notification text.
--- @param x_pos_offset number Optional horizontal position offset, defaults to 0.0.
--- @param y_pos_offset number Optional vertical position offset, defaults to 0.0.
--- @param max_background_alpha number Optional maximum background alpha (opacity), defaults to 0.95.
--- @param length number Optional length of the notification box, defaults to 0.0.
--- @param height number Optional height of the notification box, defaults to 0.0.
--- @overload fun(unique_id:string, label: string, message: string, duration_s: number, color: color):boolean
--- @overload fun(unique_id:string, label: string, message: string, duration_s: number, color: color, x_pos_offset: number):boolean
--- @overload fun(unique_id:string, label: string, message: string, duration_s: number, color: color, x_pos_offset: number, y_pos_offset: number):boolean
--- @overload fun(unique_id:string, label: string, message: string, duration_s: number, color: color, x_pos_offset: number, y_pos_offset: number, max_background_alpha: number):boolean
--- @overload fun(unique_id:string, label: string, message: string, duration_s: number, color: color, x_pos_offset: number, y_pos_offset: number, max_background_alpha: number, length: number):boolean
function core.graphics.add_notification(unique_id, label, message, duration_ms, color, x_pos_offset, y_pos_offset, max_background_alpha, length, height)
    return false
end

---@return vec2 main_menu_screen_position
function core.graphics.get_main_menu_screen_pos()
    return {}
end

---@return vec2 main_menu_screen_size
function core.graphics.get_main_menu_screen_size()
    return {}
end

--- @param unique_id string UNIQUE identifier of the notification.
--- @param delay number|nil Optional delay to trigger (eg. delay = 5.0, this function will return true if the notification was clicked 5 seconds ago), defaults to 0.0
function core.graphics.is_notification_clicked(unique_id, delay)
    return false
end

-- Returns true if the notification is being shown on screen
--- @param unique_id string UNIQUE identifier of the notification.
function core.graphics.is_notification_active(unique_id)
    return false
end

--- Retrieves the current screen position of notifications.
---@return vec2 notifications_position The screen coordinates (x, y) where notifications are displayed.
function core.graphics.get_notifications_menu_position()
    return {}
end

--- Retrieves the default size of notifications.
---@return vec2 notifications_default_size The default width and height of notifications.
function core.graphics.get_notifications_default_size()
    return {}
end

---@return string current_dragged_menu_element_pending_to_be_added_to_control_panel_label The current dragged menu element that is pending to be added to control panel
function core.graphics.get_current_control_panel_element_label()
    return ""
end

---@param label string
function core.graphics.set_current_control_panel_element_label(label) end

--- Retrieves the scaled width - Main resolution is your current resolution X, must be hardcoded. (Eg. 1920)
---@return number scaled_width
---@param value_to_scale number
---@param main_resolution number
function core.graphics.scale_width_to_screen_size(value_to_scale, main_resolution)
    return 0.0
end

--- Retrieves the scaled height - Main resolution is your current resolution Y, must be hardcoded. (Eg. 1080)
---@return number scaled_width
---@param value_to_scale number
---@param main_resolution number
function core.graphics.scale_height_to_screen_size(value_to_scale, main_resolution)
    return 0.0
end

--- Retrieves the scaled size - Main resolution is your current resolution. Must be hardcoded. (Eg. 1920*1080)
---@return vec2 scaled_size
---@param value_to_scale vec2
---@param main_resolution vec2
function core.graphics.scale_size_to_screen_size(value_to_scale, main_resolution)
    return {}
end

--- Line Of Sight
---@return boolean
---@param caster game_object
---@param target game_object
function core.graphics.is_line_of_sight(caster, target)
    return false
end

--- Trace Line
---@return boolean
---@param pos1 vec3
---@param pos2 vec3
---@param flags number
function core.graphics.trace_line(pos1, pos2, flags)
    return false
end

--- World to Screen
---@param position vec3 The 3D world position to convert.
---@return vec2 | nil
function core.graphics.w2s(position)
    return {}
end

--- World to Screen
---@return vec2 --| nil
function core.graphics.get_screen_size()
    return {}
end

--- Cursor World Position (Vec3)
---@return vec3
function core.graphics.get_cursor_world_position()
    return {}
end

--- Returns true when the main menu is open
---@return boolean
function core.graphics.is_menu_open()
    return false
end

--- Render 2D text.
---@param text string The text to render.
---@param position vec2 The position where the text will be rendered.
---@param font_size number The font size of the text.
---@param color color The color of the text.
---@param centered? boolean Indicates whether the text should be centered at the specified position. Default is false.
---@param font_id? integer The font ID. Default is 0.
function core.graphics.text_2d(text, position, font_size, color, centered, font_id) end

--- Render 3D text.
---@param text string The text to render.
---@param position vec3 The position in 3D space where the text will be rendered.
---@param font_size number The font size of the text.
---@param color color The color of the text.
---@param centered? boolean Indicates whether the text should be centered at the specified position. Default is false.
---@param font_id? integer The font ID. Default is 0.
function core.graphics.text_3d(text, position, font_size, color, centered, font_id) end

--- Get Text Width
---@return number
---@param text string The text to render.
---@param font_size number The font size of the text.
---@param font_id? integer The font ID. Default is 0.
function core.graphics.get_text_width(text, font_size, font_id)
    return 0
end

--- Draw 2D Line
---@param start_point vec2 The start point of the line.
---@param end_point vec2 The end point of the line.
---@param color color The color of the line.
---@param thickness? number The thickness of the line. Default is 1.
function core.graphics.line_2d(start_point, end_point, color, thickness) end

--- Draw 2D Rectangle Outline
---@param top_left_point vec2 The top-left corner point of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color color The color of the rectangle outline.
---@param thickness? number The thickness of the outline. Default is 1.
---@param rounding? number The rounding of corners. Default is 0.
function core.graphics.rect_2d(top_left_point, width, height, color, thickness, rounding) end

--- Draw 2D Filled Rectangle
---@param top_left_point vec2 The top-left corner point of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color color The color of the rectangle outline.
---@param rounding? number The rounding of corners. Default is 0.
function core.graphics.rect_2d_filled(top_left_point, width, height, color, rounding) end

--- Draw 3D Line
---@param start_point vec3 The start point of the line in 3D space.
---@param end_point vec3 The end point of the line in 3D space.
---@param color color The color of the line.
---@param thickness? number The thickness of the line. Default is 1.
---@param fade_factor? number The thickness of the outline. Default is 2.5.
function core.graphics.line_3d(start_point, end_point, color, thickness, fade_factor) end

--- Draw 3D Rectangle Outline
-- ---@param p1 vec3 The first corner point of the rectangle in 3D space.
-- ---@param p2 vec3 The second corner point of the rectangle in 3D space.
-- ---@param p3 vec3 The third corner point of the rectangle in 3D space.
-- ---@param p4 vec3 The fourth corner point of the rectangle in 3D space.
-- ---@param color color The color of the rectangle outline.
-- ---@param thickness? number The thickness of the outline. Default is 1.
-- function core.graphics.rect_3d(p1, p2, p3, p4, color, thickness) end

--- Draw 3D Rectangle Outline New
---@param origin vec3
---@param destination vec3
---@param color color The color of the rectangle outline.
---@param thickness? number The thickness of the line. Default is 1.
---@param fade_factor? number The thickness of the outline. Default is 2.5.
function core.graphics.rect_3d(origin, destination, width, color, thickness, fade_factor) end

--- Draw 3D Filled Rectangle
---@param p1 vec3 The first corner point of the rectangle in 3D space.
---@param p2 vec3 The second corner point of the rectangle in 3D space.
---@param p3 vec3 The third corner point of the rectangle in 3D space.
---@param p4 vec3 The fourth corner point of the rectangle in 3D space.
---@param color color The fill color of the rectangle.
function core.graphics.rect_3d_filled(p1, p2, p3, p4, color) end

--- Draw 2D Circle Outline
---@param center vec2 The center point of the circle.
---@param radius number The radius of the circle.
---@param color color The color of the circle outline.
---@param thickness? number The thickness of the outline. Default is 1.
function core.graphics.circle_2d(center, radius, color, thickness) end

--- Draw 2D Circle Outline Gradient
---@param center vec2 The center point of the circle.
---@param radius number The radius of the circle.
---@param color_1 color
---@param color_2 color
---@param color_3 color
---@param thickness? number The thickness of the outline. Default is 1.
function core.graphics.circle_2d_gradient(center, radius, color_1, color_2, color_3, thickness) end

--- Draw 2D Filled Circle
---@param center vec2 The center point of the circle.
---@param radius number The radius of the circle.
---@param color color The fill color of the circle.
function core.graphics.circle_2d_filled(center, radius, color) end

--- Draw 3D Circle Outline
---@param center vec3 The center point of the circle in 3D space.
---@param radius number The radius of the circle.
---@param color color The color of the circle outline.
---@param thickness? number The thickness of the outline. Default is 1.
---@param fade_factor? number The factor / strenght it fades out, bigger value, faster fade. Default is 2.5.
function core.graphics.circle_3d(center, radius, color, thickness, fade_factor) end

--- Draw 3D Circle Outline Percentage
---@param center vec3 The center point of the circle in 3D space.
---@param radius number The radius of the circle.
---@param color color The color of the circle outline.
---@param percentage number The percentage of the circle to render.
---@param thickness? number The thickness of the outline. Default is 1.
function core.graphics.circle_3d_percentage(center, radius, color, percentage, thickness) end

--- Draw 3D Circle Outline Gradient
---@param center vec3 The center point of the circle in 3D space.
---@param radius number The radius of the circle.
---@param color_1 color
---@param color_2 color
---@param color_3 color
---@param thickness? number The thickness of the outline. Default is 1.
function core.graphics.circle_3d_gradient(center, radius, color_1, color_2, color_3, thickness) end

--- Draw 3D Circle Outline Gradient Percentage
---@param center vec3 The center point of the circle in 3D space.
---@param radius number The radius of the circle.
---@param color_1 color
---@param color_2 color
---@param color_3 color
---@param percentage number The percentage of the circle to render.
---@param thickness? number The thickness of the outline. Default is 1.
function core.graphics.circle_3d_gradient_percentage(center, radius, color_1, color_2, color_3, percentage, thickness) end

--- Draw 3D Filled Circle
---@param center vec3 The center point of the circle in 3D space.
---@param radius number The radius of the circle.
---@param color color The fill color of the circle.
function core.graphics.circle_3d_filled(center, radius, color) end

--- Draw 2D Filled Triangle
---@param p1 vec2 The first corner point of the triangle in 2D space.
---@param p2 vec2 The second corner point of the triangle in 2D space.
---@param p3 vec2 The third corner point of the triangle in 2D space.
---@param color color The fill color of the triangle.
function core.graphics.triangle_2d_filled(p1, p2, p3, color) end

--- Draw 3D Filled Triangle
---@param p1 vec3 The first corner point of the triangle in 3D space.
---@param p2 vec3 The second corner point of the triangle in 3D space.
---@param p3 vec3 The third corner point of the triangle in 3D space.
---@param color color The fill color of the triangle.
function core.graphics.triangle_3d_filled(p1, p2, p3, color) end

--- Load Image
---@param path_to_asset string The path to the image file.
function core.graphics.load_image(path_to_asset) end

--- Draw Image
---@param image any Loaded image object.
---@param position vec2 The position to place the image.
function core.graphics.draw_image(image, position) end

---@class menu
core.menu = {}

--- Registers the menu for interaction.
function core.menu.register_menu() end

--- Creates a new tree node instance
---@return tree_node
function core.menu.tree_node()
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new checkbox instance.
---@param default_state boolean The default state of the checkbox.
---@param id string The unique identifier for the checkbox.
---@return checkbox
function core.menu.checkbox(default_state, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new checkbox instance.
---@param default_key integer The default state of the checkbox.
---@param initial_toggle_state boolean The initial toggle state of the keybind
---@param default_state boolean The default state of the checkbox
---@param show_in_binds boolean The default show in binds state of the checkbox
---@param default_mode_state integer The default show in binds state of the checkbox  -> 0 is hold, 1 is toggle, 2 is always
---@param id string The unique identifier for the checkbox.
---@return key_checkbox
function core.menu.key_checkbox(default_key, initial_toggle_state, default_state, show_in_binds,  default_mode_state, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new slider with integer values.
---@param min_value number The minimum value of the slider.
---@param max_value number The maximum value of the slider.
---@param default_value number The default value of the slider.
---@param id string The unique identifier for the slider.
---@return slider_int
function core.menu.slider_int(min_value, max_value, default_value, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new slider with floating-point values.
---@param min_value number The minimum value of the slider.
---@param max_value number The maximum value of the slider.
---@param default_value number The default value of the slider.
---@param id string The unique identifier for the slider.
---@return slider_float
function core.menu.slider_float(min_value, max_value, default_value, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new combobox.
---@param default_index number The default index of the combobox options (1-based).
---@param id string The unique identifier for the combobox.
---@return combobox
function core.menu.combobox(default_index, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new combobox_reorderable.
---@param default_index number The default index of the combobox options (1-based).
---@param id string The unique identifier for the combobox.
---@return combobox_reorderable
function core.menu.combobox_reorderable(default_index, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new keybind.
---@param default_value number The default value for the keybind.
---@param initial_toggle_state boolean The initial toggle state for the keybind.
---@param id string The unique identifier for the keybind.
---@return keybind
function core.menu.keybind(default_value, initial_toggle_state, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new button.
---@return button
---@param id string The unique identifier for the button.
function core.menu.button(id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new color picker.
---@param default_color color The default color value.
---@param id string The unique identifier for the color picker.
---@return color_picker
function core.menu.colorpicker(default_color, id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new header
---@return header
function core.menu.header()
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new text input
---@return text_input
function core.menu.text_input(id)
    return {} -- Empty return statement to implicitly return nil
end

--- Creates a new window
---@return window
function core.menu.window(window_id)
    return {} -- Empty return statement to implicitly return nil
end

