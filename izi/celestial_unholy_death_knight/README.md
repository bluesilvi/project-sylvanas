# Unholy Death Knight Rotation

An example rotation implementation for Unholy Death Knight using the IZI SDK framework. This rotation supports the **Rider of Apocalypse** hero tree and demonstrates best practices for building combat rotations.

**[📦 Download from the PS Plugin Marketplace](https://project-sylvanas.net/panel/plugins/detail/287)**

## Author

**Voltz**

## Overview

This project provides a fully functional Unholy Death Knight rotation with configurable options for cooldown usage, defensive abilities, and utility features. The rotation is designed as an example and teaching tool - while functional, it is not perfect and can be further optimized.

## AoE Talent Build

```
CwPAclESCN5uIs3wGGVadXqL3BwMDzYmxwMzMzMTDjZMzMGAAAAAAAAmZmZDzYmBAsNDzY2mZmxYGgFzihhMwsxQjFMAzAYA
```

## Features

### Rotation Logic
- **Single Target Rotation**: Optimized priority system for single target DPS
- **AoE Rotation**: Smart target switching and cleave damage handling
- **Pandemic Tracking**: Automatic disease refresh at optimal timings
- **Resource Management**: Intelligent Runic Power and Rune spending
- **Festering Wound Management**: Dynamic wound stacking and consumption

### Cooldown Management
- **Raise Abomination**: Configurable TTD thresholds
- **Apocalypse**: Smart usage with Festering Wound preparation
- **Legion of Souls**: TTD-validated burst windows
- **Unholy Assault**: Synchronized with Apocalypse minions
- **Twisted Crusade** (Artifact/Remix): Automatic Felspike timing

### Defensive Abilities
- **Anti-Magic Shell**: Magical damage forecasting
- **Lichborne**: Health-based emergency survival
- **Icebound Fortitude**: Configurable health thresholds
- **Death Strike**: Smart usage with Dark Succor proc detection

### Utility Features
- **Auto Pet Summon**: Automatically raises Ghoul when missing
- **Remix Time**: Automatic cooldown refresh when appropriate
- **Minion Tracking**: Detects active Abomination and Apocalypse minions
- **Movement Detection**: Smart spell usage during movement

## File Structure

```
death_knight_unholy/
├── main.lua        # Core rotation logic and spell priorities
├── spells.lua      # Spellbook with all ability definitions
├── menu.lua        # Configuration UI and user settings
└── README.md       # This file
```

### main.lua
Contains the actual rotation logic including:
- Single target and AoE rotation handlers
- Defensive spell logic with health forecasting
- Utility functions (pet management, Remix Time)
- Artifact power integration
- Enemy tracking and target selection

### spells.lua
Complete spellbook organized by category:
- Damage abilities (Festering Strike, Clawing Shadows, Death Coil, etc.)
- Cooldowns (Apocalypse, Raise Abomination, Unholy Assault)
- Remix abilities (Twisted Crusade, Remix Time)
- Defensives (Anti-Magic Shell, Icebound Fortitude, Lichborne)
- Utility and passive tracking

### menu.lua
Configuration interface with:
- Global enable/disable toggles
- Keybind configuration
- TTD thresholds for all cooldowns (separate for ST/AoE)
- Health thresholds for defensive abilities
- Utility automation settings
- Validator functions for rotation integration

## Configuration

All settings can be configured through the in-game menu under **"Celestial Unholy Death Knight"**.

### Cooldown Settings
Each major cooldown has configurable Time To Die (TTD) thresholds:
- Separate settings for single target and AoE scenarios
- Default: 16 seconds (ST), 20 seconds (AoE)
- Range: 1-120 seconds

### Defensive Settings
Health thresholds for automatic defensive usage:
- **Anti-Magic Shell**: 95% HP / 90% predicted HP
- **Lichborne**: 60% HP / 55% predicted HP
- **Icebound Fortitude**: 50% HP / 45% predicted HP
- **Death Strike**: 55% HP / 70% HP with Dark Succor

### Utility Settings
- **Auto Raise Dead**: Automatically summon Ghoul when missing
- **Auto Remix Time**: Use Remix Time to refresh cooldowns (requires standing still for 2.5s by default)

## Usage

1. Load the rotation script in your IZI SDK environment
2. Configure settings via the in-game menu
3. Use the rotation keybind to enable/disable (default: Unbound - set in menu)
4. Monitor the control panel for rotation status

## Rotation Priority (Simplified)

### Single Target
1. Raise Abomination (on cooldown, TTD check)
2. Legion of Souls (on cooldown, TTD check)
3. Build to 4 Festering Wounds when Apocalypse is ready
4. Apocalypse with 4+ Festering Wounds
5. Unholy Assault during Apocalypse minions
6. Maintain Virulent Plague (pandemic refresh)
7. Soul Reaper on targets below 35% HP
8. Death Coil at high Runic Power or with Sudden Doom
9. Clawing Shadows with Festering Wounds + Rotten Touch
10. Festering Strike to maintain 2+ wounds
11. Death Coil filler

### AoE (2+ targets)
1. Festering Scythe (on cooldown)
2. Soul Reaper on low HP targets
3. Raise Abomination (on cooldown)
4. Legion of Souls (on cooldown)
5. Apocalypse on lowest Festering Wound target
6. Spread Virulent Plague to all targets
7. During Death and Decay: Burst phase rotation
8. Outside Death and Decay: Build resources and maintain DoTs

## Requirements

- IZI SDK framework
- World of Warcraft (compatible version)
- Unholy Death Knight specialization
- Recommended: Rider of Apocalypse hero tree

## Key Perks

1. **Intelligent Cooldown Management** - Never waste major cooldowns on targets that will die before the ability has impact, thanks to TTD validation
2. **Automatic AoE Detection** - Seamlessly switches between single target and AoE rotations based on enemy count
3. **Pandemic Tracking** - Refreshes Virulent Plague at the optimal 30% pandemic window for maximum uptime without wasting GCDs
4. **Predictive Defensives** - Uses damage forecasting to trigger defensive abilities before you die, not after
5. **Zero-Maintenance Pet Management** - Automatically summons your Ghoul when missing, eliminating manual pet management
6. **Smart Festering Wound Optimization** - Dynamically adjusts wound stacking based on active cooldowns (e.g., holds 4 stacks for Apocalypse)
7. **Remix Time Automation** - Intelligently refreshes cooldowns during downtime without interrupting active burst windows
8. **Proc-Aware Rotation** - Prioritizes Sudden Doom and Dark Succor procs for optimal resource efficiency
9. **Fully Customizable** - Every cooldown, defensive threshold, and automation feature can be configured through an intuitive in-game menu
10. **Combat-Ready Safeguards** - Automatically skips CC'd targets and damage-immune enemies to avoid breaking crowd control or wasting resources

## Notes

- This rotation is meant as an **example** and is **not perfect**
- TTD (Time To Die) calculations help avoid wasting cooldowns on dying targets
- The rotation automatically adapts between single target and AoE scenarios
- Defensive abilities use damage forecasting to predict incoming damage

## Contributing

This is an example rotation for learning purposes. Feel free to modify and improve it for your own use cases.

## License

Educational/Example code - use and modify as needed.
