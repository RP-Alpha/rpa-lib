# rpa-lib

The core library for the RP-Alpha suite. Handles framework bridging, notifications, and common utilities.

## Features
- **Framework Agnostic**: Supports QB-Core, QBOX, and OX_CORE automatically.
- **Notification Bridge**: Unified export for sending notifications.
- **TextUI Bridge**: Unified export for showing helper text.
- **Target Bridge**: Wrapper for `ox_target` and `qb-target`.

## Installation
1. This is a dependency for ALL RP-Alpha resources.
2. Add `ensure rpa-lib` to your `server.cfg` **before** other RPA resources.

## Exports
```lua
-- Get Framework Object
local Framework = exports['rpa-lib']:GetFramework()

-- Send Notification
exports['rpa-lib']:Notify("Message", "success") -- types: success, error, info

-- Text UI
exports['rpa-lib']:TextUI("Press [E] to Interact")
exports['rpa-lib']:HideTextUI()
```

## Credits
- RP-Alpha Development Team

## License
MIT
