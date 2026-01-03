-- Server side logic
-- Currently mostly placeholders or verification
local function ServerNotify(source, msg, type, length)
    -- Trigger client event or export?
    -- Usually we just trigger a client event that calls the client export
    -- Or if generic, use framework notify
    TriggerClientEvent('rpa-lib:client:Notify', source, msg, type, length)
end

RegisterNetEvent('rpa-lib:server:Notify', function(msg, type, length)
    local src = source
    ServerNotify(src, msg, type, length)
end)

-- Export for server-side scripts to use
exports('Notify', ServerNotify)
