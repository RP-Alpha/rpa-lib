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
server_script 'server/main.lua'

lua54 'yes'

exports {
    'GetFramework',
    'GetFrameworkName',
    'AddTargetModel',
    'AddTargetZone',
    'AddGlobalVehicle',
    'RemoveZone'
}
