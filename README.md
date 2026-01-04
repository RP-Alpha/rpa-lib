# rpa-lib

<div align="center">

![GitHub Release](https://img.shields.io/github/v/release/RP-Alpha/rpa-lib?style=for-the-badge&logo=github&color=blue)
![GitHub commits](https://img.shields.io/github/commits-since/RP-Alpha/rpa-lib/latest?style=for-the-badge&logo=git&color=green)
![License](https://img.shields.io/github/license/RP-Alpha/rpa-lib?style=for-the-badge&color=orange)
![Downloads](https://img.shields.io/github/downloads/RP-Alpha/rpa-lib/total?style=for-the-badge&logo=github&color=purple)

**The Core Library for RP-Alpha Resources**

[![Discord](https://img.shields.io/badge/Discord-Join%20Us-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/rpalpha)

</div>

---

## 📋 Overview

`rpa-lib` is the **required foundation** for all RP-Alpha resources. It provides framework bridging, notification systems, and shared utilities.

### ✨ Features

- 🔄 **Framework Agnostic** - Automatic detection for QB-Core, QBOX, and OX_CORE
- 📢 **Notification Bridge** - Unified API for sending notifications
- 💬 **TextUI Bridge** - Consistent interaction prompts
- 🎯 **Target Bridge** - Wrapper for ox_target and qb-target
- 🔐 **Permissions System** - Unified permissions supporting groups + server.cfg IDs

---

## 📥 Installation

1. Download the [latest release](https://github.com/RP-Alpha/rpa-lib/releases/latest)
2. Extract to your `resources` folder
3. Add to `server.cfg`:
   ```cfg
   ensure rpa-lib
   ```

> ⚠️ **Important**: This resource must be started BEFORE all other RPA resources.

---

## 📚 Exports

### Client-Side

```lua
-- Send notification
exports['rpa-lib']:Notify("Message", "success") -- types: success, error, info

-- Text UI
exports['rpa-lib']:TextUI("[E] Interact")
exports['rpa-lib']:HideTextUI()
```

### Server-Side

```lua
-- Get Framework Object
local Framework = exports['rpa-lib']:GetFramework()

-- Send notification to player
exports['rpa-lib']:Notify(source, "Message", "success")
```

---

## 🔐 Permissions System

RP-Alpha resources support **two permission methods** that work together:

### 1. QB-Core/QBOX Groups

Built-in group checking for standard QB-Core groups (`admin`, `god`, `mod`, `dev`, `user`):

```lua
-- Check if player is admin
local isAdmin = exports['rpa-lib']:IsAdmin(source)

-- Check specific groups
local hasGroup = exports['rpa-lib']:HasGroup(source, {'admin', 'mod'})
```

### 2. Server.cfg ID-Based Permissions (Like Jaksam Scripts)

Add player identifiers directly to your `server.cfg`:

```cfg
# Global RP-Alpha permissions
setr rpa:admins "steam:110000123456789,license:abc123def456"
setr rpa:mods "steam:110000987654321,license:xyz789"
setr rpa:devs "steam:110000111111111"

# Resource-specific permissions
setr rpa_police:admin "steam:123456,license:abcdef"
setr rpa_police:manage_ranks "steam:789012"
setr rpa_mdt:view_all_records "steam:345678"
setr rpa_ambulance:revive_anyone "license:ghijkl"
```

### Permission Exports

```lua
-- Quick permission checks
exports['rpa-lib']:IsAdmin(source)        -- Admin (group or ConVar)
exports['rpa-lib']:IsModerator(source)    -- Mod (group or ConVar)
exports['rpa-lib']:IsDeveloper(source)    -- Dev (group or ConVar)

-- Group-based checks
exports['rpa-lib']:HasGroup(source, {'admin', 'mod'})

-- Job-based checks
exports['rpa-lib']:HasJob(source, {'police', 'bcso'}, minGrade)
exports['rpa-lib']:IsOnDuty(source)

-- ConVar permission check
exports['rpa-lib']:CheckConvarPermission(source, 'rpa:admins')

-- Full permission config check
local hasPerm, reason = exports['rpa-lib']:HasPermission(source, {
    groups = {'admin', 'god'},           -- QB-Core groups (OR)
    jobs = {'police'},                    -- Job names (OR)
    minGrade = 2,                         -- Minimum job grade
    onDuty = true,                        -- Must be on duty
    convar = 'rpa:admins',               -- Direct ConVar check
    resourceConvar = 'manage_ranks'       -- Resource-prefixed ConVar
}, 'police')  -- resource name for resourceConvar
```

### Finding Player Identifiers

Use the `/checkperms [playerID]` command in-game (admin only) to see:
- Player's QB-Core group
- Player's job and grade
- All player identifiers (steam, license, discord, etc.)

Common identifier formats:
- Steam: `steam:110000xxxxxxxxx`
- License: `license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- Discord: `discord:xxxxxxxxxxxxxxxxxx`

---

## ⚙️ Configuration

```lua
Config = {}
Config.Debug = false
Config.Locale = 'en'
```

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](https://github.com/RP-Alpha/.github/blob/main/CONTRIBUTING.md) first.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <sub>Built with ❤️ by the <a href="https://github.com/RP-Alpha">RP-Alpha</a> Community</sub>
</div>
