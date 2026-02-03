
--------------------------------------------------------------------------------
-- assets_example/main.lua
--
-- Requirements:
-- - Put both files here:
--   <loader_path>\scripts_data\test_assets\classicon_paladin.jpg
--   <loader_path>\scripts_data\test_assets\classicon_paladin.png
--
-- ZIP pack test:
-- - The zip pack is downloaded automatically to:
--   <loader_path>\scripts_data\zip_test_assets.zip
--
-- - Then the files are accessed as:
--   zip_test_assets\\classicon_paladin.jpg
--   zip_test_assets\\classicon_paladin.png
--
-- assets_helper require path:
-- "common/utility/assets_helper"
--------------------------------------------------------------------------------

local vec2 = require("common/geometry/vector_2")
local assets_helper = require("common/utility/assets_helper")

local color = require("common/color")

-- Local assets (already in scripts_data as real files)
local JPG_PATH = "test_assets\\classicon_paladin.jpg"
local PNG_PATH = "test_assets\\classicon_paladin.png"

-- ZIP virtual assets (come from scripts_data\\zip_test_assets.zip)
local ZIP_FOLDER = "zip_test_assets"
local ZIP_URL = "ps/1768128082013OFT0-zip_test_assets.zip"

local ZIP_JPG_PATH = "zip_test_assets\\classicon_paladin.jpg"
local ZIP_PNG_PATH = "zip_test_assets\\classicon_paladin.png"

-- Register the pack once, assets_helper will download it on-demand when missing
assets_helper:register_zip_pack(ZIP_FOLDER, ZIP_URL)

-- Optional debug, log when the zip entry becomes available
local _logged_zip_ready = false

local function on_render()
    -- 1) Local folder draw, JPG then fallback to PNG if needed
    assets_helper:draw_local_texture(
        JPG_PATH,
        vec2.new(30, 30),
        64, 64,
        color.purple(),
        false
    )

    -- 2) Local folder draw, PNG explicitly
    assets_helper:draw_local_texture(
        PNG_PATH,
        vec2.new(30, 110),
        64, 64,
        color.yellow(),
        false
    )

    -- 3) ZIP virtual draw, JPG path (fallback to PNG if jpg decode unsupported)
    -- If zip_test_assets.zip is missing, assets_helper will start downloading it automatically.
    assets_helper:draw_local_texture(
        ZIP_JPG_PATH,
        vec2.new(140, 30),
        64, 64,
        color.blue(),
        false
    )

    -- 4) ZIP virtual draw, PNG explicitly
    assets_helper:draw_local_texture(
        ZIP_PNG_PATH,
        vec2.new(140, 110),
        64, 64,
        color.red(),
        false
    )

    -- Debug log once when ready
    if not _logged_zip_ready then
        local zip_size = core.get_data_file_size("zip_test_assets.zip")
        if zip_size and zip_size > 0 then
            local bytes = core.read_data_file(ZIP_PNG_PATH)
            if bytes and #bytes > 0 then
                _logged_zip_ready = true
                core.log("zip_test_assets.zip present, size=" .. tostring(zip_size) .. ", entry bytes=" .. tostring(#bytes))
            end
        end
    end
end

core.register_on_render_callback(on_render)
