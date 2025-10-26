--[[
    Celestial Unholy Death Knight Spellbook for IZI SDK

    This file contains the complete spellbook for the Unholy Death Knight rotation.
    Each spell is defined with its spell ID(s) and organized by category for easy reference.

    Categories:
    - Damage abilities (Festering Strike, Clawing Shadows, Death Coil, etc.)
    - Cooldowns (Apocalypse, Raise Abomination, Unholy Assault, etc.)
    - Remix abilities (Artifact powers and time manipulation)
    - Defensives (Anti-Magic Shell, Icebound Fortitude, Lichborne)
    - Utility (Pet summoning)
    - Passives (Talent tracking)

    Author: Voltz
]]

local izi = require("common/izi_sdk")
local enums = require("common/enums")
local spell = izi.spell

local BUFFS = enums.buff_db

---@class dk_unholy_spells
local SPELLS =
{
    --Damage
    FESTERING_STRIKE = spell(85948),
    FESTERING_SCYTHE = spell(455397, 458128),
    CLAWING_SHADOWS = spell(207311),
    SOUL_REAPER = spell(343294),
    DEATH_COIL = spell(47541),
    EPIDEMIC = spell(207317),
    OUTBREAK = spell(77575),
    DEATH_AND_DECAY = spell(43265),
    DEATH_STRIKE = spell(49998),

    --Cooldowns
    LEGION_OF_SOULS = spell(383269),
    APOCALYPSE = spell(275699),
    RAISE_ABOMINATION = spell(455395),
    UNHOLY_ASSAULT = spell(207289),

    --Remix
    REMIX_TIME = spell(1236723),
    ARTIFACT_TWISTED_CRUSADE = spell(1237711),
    ARTIFACT_TWISTED_CRUSADE_FELSPIKE = spell(1242973),

    --Defensives
    ANTI_MAGIC_SHELL = spell(48707),
    ICEBOUND_FORTITUDE = spell(48792),
    LICHBORNE = spell(49039),

    --Utility
    RAISE_DEAD = spell(46584),

    --Passives (these are just used to check for talents)
    IMPROVED_DEATH_COIL = spell(377580),
    SUPERSTRAIN = spell(390283),
}

--For outbreak we want to track virulent plague for spreading dots with izi.spread_dot
SPELLS.OUTBREAK:track_debuff(BUFFS.VIRULENT_PLAGUE)

return SPELLS
