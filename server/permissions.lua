-- RP-Alpha Permissions System
-- Supports QB-Core/QBOX groups and server.cfg ID-based permissions (like Jaksam scripts)

local QBCore = nil
local FrameworkName = nil
local PermissionCache = {}
local CacheTimeout = 60000 -- 1 minute cache

-- Initialize framework reference
CreateThread(function()
    Wait(500) -- Wait for framework to initialize
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        FrameworkName = 'qb-core'
    elseif GetResourceState('qbx_core') == 'started' then
        QBCore = exports['qbx_core']:GetCoreObject()
        FrameworkName = 'qbox'
    end
end)

--[[
    ConVar Permission Format (server.cfg):
    
    setr rpa:admins "steam:110000123456789,license:abc123def456"
    setr rpa:mods "steam:110000987654321"
    setr rpa:police_admin "steam:110000123456789"
    setr rpa:ambulance_admin "license:xyz789"
    
    You can also define custom permission groups per resource:
    setr rpa_police:manage_ranks "steam:123,license:456"
    setr rpa_mdt:view_records "steam:789"
]]

--- Get identifiers for a player
---@param source number Player server ID
---@return table identifiers List of player identifiers
local function GetPlayerIdentifiers(source)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if id then
            table.insert(identifiers, id)
        end
    end
    return identifiers
end

--- Check if player identifier is in a ConVar permission list
---@param source number Player server ID
---@param convarName string The ConVar name to check
---@return boolean hasPermission
local function CheckConvarPermission(source, convarName)
    local convarValue = GetConvar(convarName, '')
    if convarValue == '' then
        return false
    end
    
    local identifiers = GetPlayerIdentifiers(source)
    local allowedIds = {}
    
    -- Parse comma-separated identifiers
    for id in string.gmatch(convarValue, '[^,]+') do
        allowedIds[id:gsub('%s+', '')] = true -- Trim whitespace
    end
    
    -- Check if any player identifier matches
    for _, identifier in ipairs(identifiers) do
        if allowedIds[identifier] then
            return true
        end
    end
    
    return false
end

--- Get player's QB-Core/QBOX group
---@param source number Player server ID
---@return string|nil group Player's permission group
local function GetPlayerGroup(source)
    if not QBCore then return nil end
    
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    -- QB-Core stores group in PlayerData
    if FrameworkName == 'qb-core' or FrameworkName == 'qbox' then
        return Player.PlayerData.group or 'user'
    end
    
    return 'user'
end

--- Get player's job information
---@param source number Player server ID
---@return table|nil job Player's job data
local function GetPlayerJob(source)
    if not QBCore then return nil end
    
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    return Player.PlayerData.job
end

--- Check if player has a specific QB-Core/QBOX group
---@param source number Player server ID
---@param groups string|table Group name or list of group names
---@return boolean hasGroup
local function HasGroup(source, groups)
    local playerGroup = GetPlayerGroup(source)
    if not playerGroup then return false end
    
    if type(groups) == 'string' then
        groups = { groups }
    end
    
    for _, group in ipairs(groups) do
        if playerGroup == group then
            return true
        end
    end
    
    return false
end

--- Check if player has a specific job
---@param source number Player server ID
---@param jobs string|table Job name or list of job names
---@param minGrade number|nil Minimum grade required (optional)
---@return boolean hasJob
local function HasJob(source, jobs, minGrade)
    local playerJob = GetPlayerJob(source)
    if not playerJob then return false end
    
    if type(jobs) == 'string' then
        jobs = { jobs }
    end
    
    for _, job in ipairs(jobs) do
        if playerJob.name == job then
            if minGrade then
                return playerJob.grade.level >= minGrade
            end
            return true
        end
    end
    
    return false
end

--- Check if player is on duty for their job
---@param source number Player server ID
---@return boolean onDuty
local function IsOnDuty(source)
    local playerJob = GetPlayerJob(source)
    if not playerJob then return false end
    
    return playerJob.onduty == true
end

--[[
    Main Permission Check Function
    
    Supports multiple permission check types:
    1. Group-based: { groups = {'admin', 'mod'} }
    2. Job-based: { jobs = {'police', 'ambulance'}, minGrade = 2, onDuty = true }
    3. ConVar ID-based: { convar = 'rpa:admins' }
    4. Resource-specific ConVar: { resourceConvar = 'manage_ranks' } -- Uses calling resource name
    5. Any combination of the above
    
    Permission config structure:
    {
        groups = {'admin', 'mod', 'god'},     -- QB-Core/QBOX groups (OR logic)
        jobs = {'police'},                      -- Job names (OR logic)
        minGrade = 0,                           -- Minimum job grade
        onDuty = false,                         -- Must be on duty
        convar = 'rpa:admins',                  -- Direct ConVar check
        resourceConvar = 'admin',               -- Resource-prefixed ConVar (rpa_resourcename:admin)
        allowAll = false                        -- If true, allows everyone (useful for config toggles)
    }
]]

---@param source number Player server ID
---@param permissionConfig table Permission configuration
---@param resourceName string|nil Resource name for resource-specific convars
---@return boolean hasPermission
---@return string|nil reason Reason for denial (if denied)
local function HasPermission(source, permissionConfig, resourceName)
    if not permissionConfig then
        return true, nil -- No permission config = allow all
    end
    
    if permissionConfig.allowAll then
        return true, nil
    end
    
    -- Check ConVar permissions first (highest priority, like Jaksam)
    if permissionConfig.convar then
        if CheckConvarPermission(source, permissionConfig.convar) then
            return true, nil
        end
    end
    
    -- Check resource-specific ConVar
    if permissionConfig.resourceConvar and resourceName then
        local convarName = 'rpa_' .. resourceName .. ':' .. permissionConfig.resourceConvar
        if CheckConvarPermission(source, convarName) then
            return true, nil
        end
    end
    
    -- Check group permissions
    if permissionConfig.groups and #permissionConfig.groups > 0 then
        if HasGroup(source, permissionConfig.groups) then
            return true, nil
        end
    end
    
    -- Check job permissions
    if permissionConfig.jobs and #permissionConfig.jobs > 0 then
        local hasJobPerm = HasJob(source, permissionConfig.jobs, permissionConfig.minGrade)
        if hasJobPerm then
            -- Check on-duty requirement
            if permissionConfig.onDuty then
                if IsOnDuty(source) then
                    return true, nil
                else
                    return false, 'You must be on duty'
                end
            end
            return true, nil
        end
    end
    
    return false, 'You do not have permission'
end

--- Quick check for admin permission (groups + ConVar)
---@param source number Player server ID
---@return boolean isAdmin
local function IsAdmin(source)
    -- Check ConVar first
    if CheckConvarPermission(source, 'rpa:admins') then
        return true
    end
    
    -- Check QB-Core groups
    return HasGroup(source, {'admin', 'god', 'superadmin'})
end

--- Quick check for moderator permission
---@param source number Player server ID
---@return boolean isMod
local function IsModerator(source)
    -- Check ConVar
    if CheckConvarPermission(source, 'rpa:mods') then
        return true
    end
    
    -- Admins are also mods
    if IsAdmin(source) then
        return true
    end
    
    -- Check QB-Core groups
    return HasGroup(source, {'mod', 'moderator'})
end

--- Quick check for developer permission
---@param source number Player server ID
---@return boolean isDev
local function IsDeveloper(source)
    -- Check ConVar
    if CheckConvarPermission(source, 'rpa:devs') then
        return true
    end
    
    -- Admins are also devs (usually)
    if IsAdmin(source) then
        return true
    end
    
    -- Check QB-Core groups
    return HasGroup(source, {'dev', 'developer'})
end

--- Get all permissions info for a player (useful for debugging)
---@param source number Player server ID
---@return table permInfo
local function GetPlayerPermissionInfo(source)
    return {
        group = GetPlayerGroup(source),
        job = GetPlayerJob(source),
        isAdmin = IsAdmin(source),
        isMod = IsModerator(source),
        isDev = IsDeveloper(source),
        identifiers = GetPlayerIdentifiers(source)
    }
end

-- Export all permission functions
exports('HasPermission', HasPermission)
exports('IsAdmin', IsAdmin)
exports('IsModerator', IsModerator)
exports('IsDeveloper', IsDeveloper)
exports('HasGroup', HasGroup)
exports('HasJob', HasJob)
exports('IsOnDuty', IsOnDuty)
exports('GetPlayerGroup', GetPlayerGroup)
exports('GetPlayerJob', GetPlayerJob)
exports('CheckConvarPermission', CheckConvarPermission)
exports('GetPlayerPermissionInfo', GetPlayerPermissionInfo)

-- Admin command to check permissions (for debugging)
RegisterCommand('checkperms', function(source, args, rawCommand)
    if source == 0 then
        print('[rpa-lib] This command must be run in-game')
        return
    end
    
    if not IsAdmin(source) then
        TriggerClientEvent('rpa-lib:client:Notify', source, 'No permission', 'error', 3000)
        return
    end
    
    local targetId = tonumber(args[1]) or source
    local info = GetPlayerPermissionInfo(targetId)
    
    print('--- Permission Info for Player ' .. targetId .. ' ---')
    print('Group: ' .. (info.group or 'none'))
    print('Job: ' .. (info.job and info.job.name or 'none') .. ' (Grade: ' .. (info.job and info.job.grade.level or 0) .. ')')
    print('Admin: ' .. tostring(info.isAdmin))
    print('Mod: ' .. tostring(info.isMod))
    print('Dev: ' .. tostring(info.isDev))
    print('Identifiers:')
    for _, id in ipairs(info.identifiers) do
        print('  - ' .. id)
    end
    
    TriggerClientEvent('rpa-lib:client:Notify', source, 'Check server console for permission info', 'info', 5000)
end, false)

print('[rpa-lib] Permissions system loaded')
