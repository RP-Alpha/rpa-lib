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
