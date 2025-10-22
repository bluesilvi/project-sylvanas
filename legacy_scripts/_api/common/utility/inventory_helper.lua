
--[[
Example:
---@type inventory_helper
local inventory = require("common/utility/inventory_helper")
inventory: -> IntelliSense
Warning: Access with ":", not "."
]]

-- This library centralizes inventory management.
-- Simplifying access to items in all bags, bank slots, and tracking specific consumables like potions and elixirs.

---@class slot_data
---@field public item game_object          -- The item object in this slot
---@field public global_slot number        -- Global slot identifier
---@field public bag_id integer            -- ID of the bag containing the item
---@field public bag_slot integer          -- Slot number within the bag
---@field public stack_count integer       -- Stack count of the item in this slot

---@class consumable_data
---@field public is_mana_potion boolean    -- Whether the item is a mana potion
---@field public is_health_potion boolean  -- Whether the item is a health potion
---@field public is_damage_bonus_potion boolean -- Whether the item is a damage bonus potion
---@field public item game_object          -- The item object for the consumable
---@field public bag_id integer            -- ID of the bag containing the item
---@field public bag_slot integer          -- Slot number within the bag
---@field public stack_count integer       -- Stack count of the item in this slot

---@class inventory_helper
---@field public get_all_slots fun(self: inventory_helper): table<slot_data> 
---@field public get_character_bag_slots fun(self: inventory_helper): table<slot_data> 
---@field public get_bank_slots fun(self: inventory_helper): table<slot_data> 
---@field public get_current_consumables_list fun(self: inventory_helper): table<consumable_data> 
---@field public update_consumables_list fun(self: inventory_helper)
---@field public debug_print_consumables fun(self: inventory_helper)
