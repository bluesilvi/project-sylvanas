
---@class tree_node
---@field public is_open fun():boolean
---@field public render fun(self:tree_node, header:string, callback:function):nil
---@field public get_widget_bounds fun(self:tree_node):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public set_open_state fun(self:tree_node, state:boolean):nil
---@class checkbox
---@field public get_state fun():boolean
---@field public get_type fun(self:checkbox)
---@field public set fun(self: checkbox, new_state:boolean):nil
---@field public render fun(self:checkbox, label:string, tooltip:string|nil):nil
---@field public get_widget_bounds fun(self:checkbox):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.

---@class key_checkbox
---@field public get_main_checkbox_state fun(self:key_checkbox):boolean
---@field public get_key_code fun(self:key_checkbox):integer
---@field public get_keybind_state fun(self:key_checkbox):integer
---@field public set_toggle_state fun(self:key_checkbox, state:boolean):nil
---@field public set_key fun(self:key_checkbox, key:integer):nil
---@field public set_mode fun(self:key_checkbox, mode:integer):nil
---@field public should_show_on_control_panel fun(self:key_checkbox):boolean
---@field public get_mode fun(self:key_checkbox):integer -- 0 is hold, 1 is toggle, 2 is always
---@field public get_type fun(self:key_checkbox)
---@field public render fun(self:key_checkbox, label:string, tooltip:string|nil):nil

---@class slider_int
---@field public get fun():number
---@field public get_type fun(self:slider_int)
---@field public set fun(self:slider_int, new_value:integer):nil
---@field public render fun(self:slider_int, label:string, tooltip:string|nil):nil
---@field public get_widget_bounds fun(self:slider_int):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.

---@class slider_float
---@field public get fun():number
---@field public get_type fun(self:slider_float)
---@field public set fun(self:slider_float, new_value:number):nil
---@field public render fun(self:slider_float, label:string, tooltip:string|nil):nil
---@field public get_widget_bounds fun(self:slider_float):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.

---@class combobox
---@field public get fun():number
---@field public get_type fun(self:combobox)
---@field public get_label fun(self:keybind):string -- The menu element needs to be rendered for this to return a string different than ""
---@field public get_widget_bounds fun(self:combobox):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public set fun(self:combobox, new_value:number):nil
---@field public is_showing_on_control_panel fun(self:combobox):boolean
---@field public set_is_showing_on_control_panel fun(self:combobox):nil
---@field public render fun(self:combobox, label:string, options:table, tooltip:string|nil):nil

---@class combobox_reorderable
---@field public get fun():number
---@field public get_type fun(self:combobox_reorderable)
---@field public render fun(self:combobox_reorderable, label:string, options:table, tooltip:string|nil):nil

---@class keybind
---@field public get_type fun(self:keybind)
---@field public get_label fun(self:keybind):string -- The menu element needs to be rendered for this to return a string different than ""
---@field public get_state fun(self:keybind):boolean
---@field public get_key_code fun(self:keybind):integer
---@field public get_widget_bounds fun(self:keybind):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public get_toggle_state fun(self:keybind):boolean
---@field public set_key fun(self:keybind, new_key:number):nil
---@field public set_is_showing_on_control_panel fun(self:keybind):nil
---@field public is_showing_on_control_panel fun(self:keybind):boolean
---@field public set_toggle_state fun(self:keybind, new_state:boolean):nil
---@field public render fun(self:keybind, label:string, tooltip:string|nil):nil

---@class button
---@field public get_type fun(self:button)
---@field public is_clicked fun(self:button):boolean
---@field public get_widget_bounds fun(self:button):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public render fun(self:button, label:string, tooltip:string|nil):nil

---@class text_input
---@field public get_type fun(self:text_input)
---@field public get_text fun(self:text_input):string
---@field public get_widget_bounds fun(self:text_input):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public get_text_as_number fun(self:text_input):number
---@field public render fun(self:text_input, label:string, tooltip:string|nil):nil

---@class color_picker
---@field public get fun():color
---@field public get_type fun(self:color_picker)
---@field public get_widget_bounds fun(self:color_picker):table -- Returns a table with 2 elements, min and max. get_widget_bounds().min is the left border of the widget, and .max is the right border.
---@field public render fun(self:color_picker, label:string, tooltip:string|nil):nil

---@class header
---@field public get_type fun(self:header)
---@field public render fun(self:header, label:string, color:color):nil

---@class window
---@field public set_window_cross_round fun(self:window):nil
---@field public set_initial_size fun(self:window, size:vec2):nil
---@field public set_initial_position fun(self:window, pos:vec2):nil
---@field public set_visibility fun(self:window, visibility:boolean):nil
---@field public set_next_widget_width fun(self:window, width:number):nil
---@field public set_next_window_padding fun(self:window, padding:vec2):nil
---@field public set_next_window_min_size fun(self:window, min_size:vec2):nil
---@field public set_next_window_items_spacing fun(self:window, spacing:vec2):nil
---@field public set_next_window_items_inner_spacing fun(self:window, inner_spacing:vec2):nil

---@class window
---@field public get_size fun(self:window):vec2
---@field public get_position fun(self:window):vec2
---@field public get_mouse_pos fun(self:window):vec2
---@field public get_text_size fun(self:window, text:string):vec2
---@field public force_window_size fun(self:window, size:vec2):nil
---@field public get_text_centered_x_pos fun(self:window, text:string):number
---@field public set_current_context_dynamic_drawing_offset fun(self:window, offset:vec2):nil
---@field public get_current_context_dynamic_drawing_offset fun(self:window):vec2
---@field public add_artificial_item_bounds fun(self:window, bounds_start:vec2, bounds_end:vec2):nil

---@class window
---@field public is_being_shown fun(self:window):boolean
---@field public is_animation_finished fun(self:window, id:integer):boolean
---@field public is_rect_clicked fun(self:window, rect_min:vec2, rect_max:vec2):boolean
---@field public is_mouse_hovering_rect fun(self:window, rect_min:vec2, rect_max:vec2):boolean
---@field public is_rect_double_clicked fun(self:window, rect_min:vec2, rect_max:vec2):boolean

---@class window
---@field public render_text fun(self:window, font_id:integer, pos_offset:vec2, col:color, text:string):nil
--note: you can also pass special rect rounding flags after the thickness parameter (up to 4 flags, integers). Check enums to see what these flags mean.
---@field public render_rect fun(self:window, pos_min_offset:vec2, pos_max_offset:vec2, col:color, rounding:number, thickness:number):nil
--note: you can also pass special rect rounding flags after the thickness parameter (up to 4 flags, integers). Check enums to see what these flags mean.
---@field public render_rect_filled fun(self:window, pos_min_offset:vec2, pos_max_offset:vec2, col:color, rounding:number):nil
--note: you can also pass special rect rounding flags after the thickness parameter (up to 4 flags, integers). Check enums to see what these flags mean.
---@field public render_rect_filled_multicolor fun(self:window, pos_min_offset:vec2, pos_max_offset:vec2, col_upr_left:color, col_upr_right:color, col_bot_right:color, col_bot_left:color, rounding:number):nil
---@field public render_circle fun(self:window, center:vec2, radius:number, color:color, thickness:number):nil
---@field public render_circle_filled fun(self:window, center:vec2, radius:number, color:color):nil
---@field public render_bezier_quadratic fun(self:window, p1:vec2, p2:vec2, p3:vec2, color:color, thickness:number, num_segments:integer):nil
---@field public render_bezier_cubic fun(self:window, p1:vec2, p2:vec2, p3:vec2, p4:vec2, color:color, thickness:number, num_segments:integer):nil
---@field public render_triangle fun(self:window, p1:vec2, p2:vec2, p3:vec2, col:color, thickness:number):nil
---@field public render_triangle_filled fun(self:window, p1:vec2, p2:vec2, p3:vec2, col:color):nil
---@field public render_triangle_filled_multi_color fun(self:window, p1:vec2, p2:vec2, p3:vec2, col_1:color, col_2:color, col_3:color):nil
---@field public render_line fun(self:window, p1:vec2, p2:vec2, col:color, thickness:number):nil
--- sets the background of the window (call before begin) to a multi-colored rectangle with the given colors. If this function is called, the color passed to the begin function is ignored.
---@field public set_background_multicolored fun(self:window, top_left_color:color, top_right_color:color, bot_right_color:color, bot_left_color:color)nil
---forces the next window position. Call before begin.
---@field public force_next_begin_window_pos fun(self:window, position:vec2):nil
---stops forcing the next window position 
---@field public stop_forcing_position fun(self:window):nil
---function to avoid console errors when calling set_next_window_padding or spacing
---@field public set_end_called_state fun(self:window):nil

---@class window
---@field public push_font fun(self:window, font_id:integer):nil
---@field public add_menu_element_pos_offset fun(self:window, pos_offset:vec2):nil
---@field public begin_group fun(self:window, begin_func:function):nil
---@field public begin_window_sub_context fun(self:window, offset:vec2, add_flags:boolean, begin_func:function):nil
---@field public set_next_window_close_cross_pos_offset fun(self:window, offset:vec2):nil
---@field public render_text_clipped fun(self:window, rect_start:vec2, rect_end:vec2, text:string):nil
---@field public block_input_capture fun(self:window):nil
---@field public begin_popup fun(self:window, bg_color:color, border_color:color, size:vec2, pos:vec2, is_close_on_release:boolean, is_triggering_from_button:boolean, begin_func:function):boolean
--note: you can also pass special_window_flag_1:integer, special_window_flag_2:integer, special_window_flag_3:integer after the cross_style parameter. Check enums to see what these parameters represent

---@class window
local window = {}

--- Begins rendering the window with various options.
--- @param self window The window object.
--- @param resizing_flag integer The flag for resizing options.
--- @param is_adding_close_cross boolean Whether to add a close cross to the window.
--- @param bg_color color The background color of the window.
--- @param border_color color The border color of the window.
--- @param cross_style integer The style of the close cross.
--- @param begin_func function The function to execute when beginning the window.
--- @return boolean Indicates if the window is open.
--- @overload fun(self: window, resizing_flag: integer, is_adding_close_cross: boolean, bg_color: color, border_color: color, cross_style: integer, special_window_flag_1: integer, begin_func: function): boolean
--- @overload fun(self: window, resizing_flag: integer, is_adding_close_cross: boolean, bg_color: color, border_color: color, cross_style: integer, special_window_flag_1: integer, special_window_flag_2: integer, begin_func: function): boolean
--- @overload fun(self: window, resizing_flag: integer, is_adding_close_cross: boolean, bg_color: color, border_color: color, cross_style: integer, special_window_flag_1: integer, special_window_flag_2: integer, special_window_flag_3: integer, begin_func: function): boolean
function window:begin(resizing_flag, is_adding_close_cross, bg_color, border_color, cross_style, begin_func, ...)
    -- Function implementation
    return false
end

---@class window
---@field public draw_next_dynamic_widget_on_new_line fun(self:window):nil
---@field public draw_next_dynamic_widget_on_same_line fun(self:window, offset_from_start:number|nil, spacing:number|nil):nil
---@field public add_text_on_dynamic_pos fun(self:window, col:color, text:string):nil
---@field public add_separator fun(self:window, right_sep_offset:number, left_sep_offset:number, y_offset:number, width_offset:number, custom_color:color):nil
---@field public animate_widget fun(self:window, animation_id:integer, start_pos:vec2, end_pos:vec2, starting_alpha:integer, max_alpha:integer, alpha_speed:number, movement_speed:number, only_once:boolean):table
---@field public make_loading_circle_animation fun(self:window, id:integer, center:vec2, radius:number, color:color, thickness:number, animation_type:integer)