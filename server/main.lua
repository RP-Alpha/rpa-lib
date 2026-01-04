-- RP-Alpha Library - Server Side
-- Framework Bridge for QB-Core, QBOX, and OX_CORE

local QBCore = nil
local FrameworkName = nil

-- Detect and initialize framework
CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        FrameworkName = 'qb-core'
    elseif GetResourceState('qbx_core') == 'started' then
        QBCore = exports['qbx_core']:GetCoreObject()
        FrameworkName = 'qbox'
    elseif GetResourceState('ox_core') == 'started' then
        -- OX uses different patterns
        FrameworkName = 'ox_core'
    end
    
    if FrameworkName then
        print('[rpa-lib] Server initialized with framework: ' .. FrameworkName)
    else
        print('[rpa-lib] WARNING: No supported framework detected!')
    end
end)

-- Framework getter exports
local function GetFramework()
    return QBCore
end

local function GetFrameworkName()
    return FrameworkName
end

exports('GetFramework', GetFramework)
exports('GetFrameworkName', GetFrameworkName)

-- Notification system
local function ServerNotify(source, msg, type, length)
    TriggerClientEvent('rpa-lib:client:Notify', source, msg, type, length)
end

RegisterNetEvent('rpa-lib:server:Notify', function(msg, type, length)
    local src = source
    ServerNotify(src, msg, type, length)
end)

exports('Notify', ServerNotify)
