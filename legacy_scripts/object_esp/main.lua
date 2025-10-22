--[[
    This plugin walks you through line by line how we can create object ESP with the Project Sylvanas API
    In this example we will be creating ESP for Ancient Mana for Legion Remix,
    however, you can add whatever object IDs you wish in the table below.

    What you will learn:
        - Best practices such as nilness checks defining constants instead of using magic numbers or other static values
        - Why you should prefer traditional for loop over ipairs or pairs when working with large tables
        - How to draw basic text ESP on an object's position
        - How to leverage caching to improve performance
        - How to properly loop through the object list
        - How to use use labels in order to continue in loops to the next iteration

    Author: Voltz
]]

local object_ids = --Define Object IDs we want to track and draw
{
    --We set the object ID as the key and value to true so we do not need to iterate over the table
    --Instead we can directly check if we want to draw the object by using the object ID as the key
    --Examples:
    --object_ids[252408] returns true -> we should cache the object for drawing
    --object_ids[123456] returns false -> we should not cache the object for drawing
    [252408] = true, --Ancient Mana Shard (gives 10 ancient mana)
    [252772] = true, --Ancient Mana Chunk (gives 20 ancient mana)
    [252774] = true, --Ancient Mana Crystal (gives 50 - 100 ancient mana)
}

local color = require("common/color") --Import color module

--Define our drawing constants
local TEXT_COLOR = color.white(200) --Our text color
local TEXT_SIZE = 12                --Our text font size
local TEXT_CENTERED = true          --Should our text be centered?
local TEXT_FONT = 10                --Our font ID
local TEXT_Z_OFFSET = -0.25         --How much to offset the Z position (up and down) by when rendering the object name

--Define our caching contants and variables
local CACHE_UPDATE_RATE_MS = 500 --How frequently the cache should be updated in miliseconds
local last_cache_update_ms = 0   --The last time the cache was updated in miliseconds

---@type game_object[]
local objects_to_draw = {} --A list of relevant objects to draw

--Handle rendering our objects
core.register_on_render_callback(function()
    --Loop through object cache and draw each object, we use a traditional for loop instead of ipairs or pairs to we iterate over our objects efficiently without the overhead of ipairs (slower) or pairs (slowest)
    for i = 1, #objects_to_draw do
        local object = objects_to_draw[i] --Get our object from the cache by its index

        --Make sure the object is valid if not continue to the next object
        if not object or not object.is_valid or not object:is_valid() then
            --Jumps the script to the continue label at the end of the loop to go to the next object
            goto continue
        end

        local name = object:get_name()    --Get the name of the object
        local pos = object:get_position() --Get the position of the object
        local scale = object:get_scale()  --Get the scale of the object

        --Offset the Z position (up and down) downards by the z offset scaled by the object's scale so it is positioned correctly for any object size
        pos.z = pos.z + TEXT_Z_OFFSET * scale

        --Draw the name of the object at it's position
        core.graphics.text_3d(name, pos, TEXT_SIZE, TEXT_COLOR, TEXT_CENTERED, TEXT_FONT)

        --Defines our label where we want continue to be located in our code
        ::continue::
    end
end)

--Update our object cache so we do not iterate over the entire list of objects every game tick and impact our FPS negatively
--NOTE: When using unit manager or izi to access enemies we do not need to do this since they return from cached lists and it is already handled for us
--This is only to teach you concept of caching and why its important
--Alteneratively we can just use the unit_manager:get_cache_object_list which handles caching for us
core.register_on_update_callback(function()
    local current_time_ms = core.game_time()                                 --Get the current game time
    local time_since_last_update_ms = current_time_ms - last_cache_update_ms --Calculate the time since the last update

    if time_since_last_update_ms > CACHE_UPDATE_RATE_MS then                 --Check to see if it's time to update the cache
        local objects = core.object_manager:get_all_objects()                --Get all the game objects

        objects_to_draw = {}                                                 --Reset our object cache

        for i = 1, #objects do                                               --Loop through the objects so we can find the ones we want to draw
            local object = objects[i]                                        --Get the object by its index
            local id = object:get_npc_id()                                   --Get the object's ID

            if object_ids[id] then                                           --Check if the object's ID is in our list of IDs we want to draw
                table.insert(objects_to_draw, object)                        --Insert the object into our cache
            end
        end

        last_cache_update_ms = current_time_ms --Update the last cache update time so we know when to update it again
    end
end)
