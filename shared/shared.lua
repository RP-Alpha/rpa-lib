local Framework = nil
local FrameworkName = nil

function GetFramework()
    if Framework then return Framework end

    if GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        FrameworkName = 'qb-core'
    elseif GetResourceState('qbox-core') == 'started' then -- qbox usually runs ON TOP of qb-core but has its own core object if using new standard? 
        -- Actually check qbox-core first if it exists? 
        -- Mindset says:
        -- elseif GetResourceState('qbox-core') == 'started' then
        --    Framework = exports['qbox-core']:GetCoreObject()
        Framework = exports['qbox-core']:GetCoreObject()
        FrameworkName = 'qbox'
    elseif GetResourceState('ox_core') == 'started' then
        Framework = require '@ox_core/lib/init'
        FrameworkName = 'ox_core'
    end

    return Framework
end

function GetFrameworkName()
    if not FrameworkName then GetFramework() end
    return FrameworkName
end

exports('GetFramework', GetFramework)
exports('GetFrameworkName', GetFrameworkName)
