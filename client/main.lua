local function Notify(msg, type, length)
    type = type or 'primary'
    length = length or 5000

    if GetResourceState('rpa-notify') == 'started' then
        return exports['rpa-notify']:Notify(msg, type, length)
    end

    -- Fallback
    local fwName = GetFrameworkName()
    if fwName == 'qb-core' then
        local QBCore = GetFramework()
        QBCore.Functions.Notify(msg, type, length)
    elseif fwName == 'qbox' then
        exports.qbx_core:Notify(msg, type, length)
    elseif fwName == 'ox_core' then
        -- Attempt to use ox_lib if available, else print warning
        if GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:notify({description = msg, type = type, duration = length})
        end
    end
end

local function TextUI(msg, type)
    type = type or 'info'
    
    if GetResourceState('rpa-textui') == 'started' then
        return exports['rpa-textui']:Show(msg, type)
    end
    
    -- Fallbacks
    local fwName = GetFrameworkName()
    if fwName == 'qb-core' then
        exports['qb-core']:DrawText(msg, type)
    elseif fwName == 'ox_core' or GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:showTextUI(msg, {position = "right-center"})
    end
end

local function HideTextUI()
    if GetResourceState('rpa-textui') == 'started' then
        return exports['rpa-textui']:Hide()
    end

    -- Fallbacks
    local fwName = GetFrameworkName()
    if fwName == 'qb-core' then
        exports['qb-core']:HideText()
    elseif fwName == 'ox_core' or GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:hideTextUI() 
    end
end

exports('Notify', Notify)
exports('TextUI', TextUI)
exports('HideTextUI', HideTextUI)

-- Event handler for server-triggered notifications
RegisterNetEvent('rpa-lib:client:Notify', function(msg, type, length)
    Notify(msg, type, length)
end)

-- Teleport function for spawn and other resources
local function Teleport(coords)
    local ped = PlayerPedId()
    
    -- Handle different coord formats
    local x, y, z, w
    if type(coords) == 'vector3' then
        x, y, z = coords.x, coords.y, coords.z
    elseif type(coords) == 'vector4' then
        x, y, z, w = coords.x, coords.y, coords.z, coords.w
    elseif type(coords) == 'table' then
        x = coords.x or coords[1]
        y = coords.y or coords[2]
        z = coords.z or coords[3]
        w = coords.w or coords[4]
    end
    
    if not x or not y or not z then return false end
    
    SetEntityCoords(ped, x, y, z, false, false, false, false)
    if w then
        SetEntityHeading(ped, w)
    end
    
    return true
end

exports('Teleport', Teleport)

-- Event handler for server-triggered teleports
RegisterNetEvent('rpa-lib:client:Teleport', function(coords)
    Teleport(coords)
end)
