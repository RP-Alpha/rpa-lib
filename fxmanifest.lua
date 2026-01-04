fx_version 'cerulean'
game 'gta5'

author 'RP-Alpha'
description 'RP-Alpha Shared Library'
version '1.0.0'

shared_scripts {
    'shared/locale.lua',
    'locales/en.lua',
    'shared/shared.lua',
    'config.lua'
}
client_scripts {
    'client/main.lua',
    'client/target.lua'
}
server_scripts {
    'server/main.lua',
    'server/permissions.lua'
}

lua54 'yes'

-- Client-side exports
exports {
    'GetFramework',
    'GetFrameworkName',
    'AddTargetModel',
    'AddTargetZone',
    'AddGlobalVehicle',
    'RemoveZone',
    'Notify',
    'TextUI',
    'HideTextUI',
    'Teleport'
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
