fx_version 'cerulean'
game 'gta5'

author 'RP-Alpha'
description 'RP-Alpha Shared Library'
version '1.1.0'

-- ox_lib is highly recommended for menu functionality
-- Without it, admin menus will have limited functionality
dependencies {
    '/onesync',
}

shared_scripts {
    '@ox_lib/init.lua', -- Optional but recommended
    'shared/locale.lua',
    'locales/en.lua',
    'shared/shared.lua',
    'config.lua'
}
client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/menu.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/permissions.lua'
}

lua54 'yes'

-- Client-side exports
exports {
    -- Framework
    'GetFramework',
    'GetFrameworkName',
    -- Target System
    'AddTargetModel',
    'AddTargetZone',
    'AddGlobalVehicle',
    'RemoveZone',
    -- Notifications
    'Notify',
    'TextUI',
    'HideTextUI',
    -- Movement
    'Teleport',
    -- Menu System
    'GetMenuType',
    'RegisterMenu',
    'OpenMenu',
    'CloseMenu',
    'InputDialog',
    'ConfirmDialog',
    'ProgressBar',
    'SelectList',
    'ColorPicker',
    'CoordsInput'
}

-- Server-side exports
server_exports {
    'GetFramework',
    'GetFrameworkName',
    'Notify',
    -- Permission exports
    'HasPermission',
    'IsAdmin',
    'IsModerator',
    'IsDeveloper',
    'HasGroup',
    'HasJob',
    'IsOnDuty',
    'GetPlayerGroup',
    'GetPlayerJob',
    'CheckConvarPermission',
    'GetPlayerPermissionInfo'
}
