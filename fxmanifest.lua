fx_version 'cerulean'
game 'gta5'

author 'RP-Alpha'
description 'RP-Alpha Shared Library'
version '1.0.0'

shared_script 'shared/shared.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

lua54 'yes'

exports {
    'GetFramework',
    'GetFrameworkName'
}
