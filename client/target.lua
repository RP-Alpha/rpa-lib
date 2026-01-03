local Config = {}
local TargetType = nil

-- Detect available target system
CreateThread(function()
    if GetResourceState('ox_target') == 'started' then
        TargetType = 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        TargetType = 'qb-target'
    end
end)

local function AddTargetModel(models, options)
    if not TargetType then return end

    if TargetType == 'ox_target' then
        exports.ox_target:addModel(models, options)
    elseif TargetType == 'qb-target' then
        exports['qb-target']:AddTargetModel(models, {
            options = options,
            distance = 2.5
        })
    end
end

local function AddTargetZone(name, coords, size, options, debug)
    if not TargetType then return end

    if TargetType == 'ox_target' then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = size,
            rotation = options.rotation or 0,
            debug = debug,
            options = options.options
        })
    elseif TargetType == 'qb-target' then
        -- Convert vector3 size to length/width/minZ/maxZ approximately if needed
        -- qb-target definition: AddBoxZone(name, coords, length, width, data)
        local length = size.y
        local width = size.x
        
        exports['qb-target']:AddBoxZone(name, coords, length, width, {
            name = name,
            heading = options.rotation or 0,
            debugPoly = debug,
            minZ = coords.z - (size.z/2),
            maxZ = coords.z + (size.z/2),
        }, {
            options = options.options,
            distance = 2.5
        })
    end
end

local function AddGlobalVehicle(options)
    if not TargetType then return end

    if TargetType == 'ox_target' then
        exports.ox_target:addGlobalVehicle(options)
    elseif TargetType == 'qb-target' then
        exports['qb-target']:AddGlobalVehicle({
            options = options,
            distance = 2.5
        })
    end
end

local function RemoveZone(name)
    if not TargetType then return end

    if TargetType == 'ox_target' then
        exports.ox_target:removeZone(name)
    elseif TargetType == 'qb-target' then
        exports['qb-target']:RemoveZone(name)
    end
end

exports('AddTargetModel', AddTargetModel)
exports('AddTargetZone', AddTargetZone)
exports('AddGlobalVehicle', AddGlobalVehicle)
exports('RemoveZone', RemoveZone)
