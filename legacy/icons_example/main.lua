
--------------------------------------------------------------------------------
-- icons_example/main.lua
--
-- Purpose:
-- - Demonstrate icons_helper downloading and drawing icons from Zamimg
-- - Shows name mode and direct URL mode
--
-- Notes:
-- - First run downloads, later frames reuse cached tex_id
-- - If persist_to_disk=true, it will also save bytes into scripts_data\\cache\\wowhead_icons
--------------------------------------------------------------------------------

local vec2 = require("common/geometry/vector_2")
local icons_helper = require("common/utility/icons_helper")
local color = require("common/color")

local function on_render()

    -- 1) Simple draw by wowhead slug
    icons_helper:draw_icon(
        "classicon-warlock",
        vec2.new(30, 30),
        64, 64,
        color.purple(),
        false,
        {
            size = "large",
            persist_to_disk = true,
        }
    )

    -- 2) Another icon
    icons_helper:draw_icon(
        "inv_misc_food_72",
        vec2.new(110, 30),
        64, 64,
        color.yellow(),
        false,
        {
            size = "large",
            persist_to_disk = true,
        }
    )

    -- 3) Direct URL mode (advanced)
    icons_helper:draw_icon(
        "https://wow.zamimg.com/images/wow/icons/large/classicon_warrior.jpg",
        vec2.new(190, 30),
        64, 64,
        color.red(),
        false,
        {
            persist_to_disk = false,
        }
    )
end

core.register_on_render_callback(on_render)
