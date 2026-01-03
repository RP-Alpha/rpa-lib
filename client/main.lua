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
