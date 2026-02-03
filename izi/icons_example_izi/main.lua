
--------------------------------------------------------------------------------
-- icons_example_izi/main.lua
--
-- Purpose:
-- - Demonstrate izi.draw_icon downloading and drawing icons from Zamimg
-- - Shows name mode and direct URL mode
--
-- Notes:
-- - First run downloads, later frames reuse cached tex_id
-- - If persist_to_disk=true, it will also save bytes into scripts_data\\cache\\wowhead_icons
--------------------------------------------------------------------------------

local izi = require("common/izi_sdk")
local color = require("common/color")

local function on_render()

    -- 1) Simple draw by wowhead slug
    izi.draw_icon(
        "classicon-warlock",
        izi.vec2(30, 30),
        64, 64,
        color.purple(),
        false,
        {
            size = "large",
            persist_to_disk = true,
        }
    )

    -- 2) Another icon
    izi.draw_icon(
        "inv_misc_food_72",
        izi.vec2(110, 30),
        64, 64,
        color.yellow(),
        false,
        {
            size = "large",
            persist_to_disk = true,
        }
    )

    -- 3) Direct URL mode (advanced)
    izi.draw_icon(
        "https://wow.zamimg.com/images/wow/icons/large/classicon_warrior.jpg",
        izi.vec2(190, 30),
        64, 64,
        color.red(),
        false,
        {
            persist_to_disk = false,
        }
    )
end

core.register_on_render_callback(on_render)
