-- RP-Alpha Admin Menu Utilities
-- Wrapper for ox_lib menus with fallback support

local MenuType = nil
local OpenMenus = {}

-- Detect available menu system
CreateThread(function()
    Wait(100)
    if GetResourceState('ox_lib') == 'started' then
        MenuType = 'ox_lib'
    elseif GetResourceState('qb-menu') == 'started' then
        MenuType = 'qb-menu'
    end
    
    if MenuType then
        print('[rpa-lib] Menu system detected: ' .. MenuType)
    else
        print('[rpa-lib] WARNING: No menu system detected (ox_lib recommended)')
    end
end)

--- Get the current menu type
---@return string|nil menuType
local function GetMenuType()
    return MenuType
end

--[[
    Universal Menu Format:
    {
        id = 'unique_menu_id',
        title = 'Menu Title',
        options = {
            {
                title = 'Option Title',
                description = 'Option description',
                icon = 'fas fa-icon',
                arrow = true,                    -- Show arrow (for submenus)
                disabled = false,
                onSelect = function() end,       -- Callback when selected
                args = {},                       -- Arguments passed to onSelect
                menu = 'submenu_id',             -- Open submenu instead of callback
                serverEvent = 'event:name',      -- Trigger server event
                clientEvent = 'event:name',      -- Trigger client event
                metadata = { key = 'value' },    -- Display metadata
            }
        },
        onClose = function() end,
        onBack = function() end,
    }
]]

--- Register a menu for later use
---@param menuData table Menu configuration
local function RegisterMenu(menuData)
    if not MenuType then return false end
    
    if MenuType == 'ox_lib' then
        lib.registerContext({
            id = menuData.id,
            title = menuData.title,
            menu = menuData.parent,
            onExit = menuData.onClose,
            onBack = menuData.onBack,
            options = ConvertToOxOptions(menuData.options)
        })
        return true
    elseif MenuType == 'qb-menu' then
        -- Store for qb-menu (it doesn't have pre-registration)
        OpenMenus[menuData.id] = menuData
        return true
    end
    
    return false
end

--- Convert universal options to ox_lib format
---@param options table Universal options
---@return table oxOptions
function ConvertToOxOptions(options)
    local oxOptions = {}
    
    for _, opt in ipairs(options) do
        local oxOpt = {
            title = opt.title,
            description = opt.description,
            icon = opt.icon,
            arrow = opt.arrow or (opt.menu ~= nil),
            disabled = opt.disabled,
            menu = opt.menu,
            serverEvent = opt.serverEvent,
            event = opt.clientEvent,
            args = opt.args,
            metadata = opt.metadata,
        }
        
        -- Handle onSelect callback
        if opt.onSelect and not opt.menu and not opt.serverEvent and not opt.clientEvent then
            oxOpt.onSelect = opt.onSelect
        end
        
        table.insert(oxOptions, oxOpt)
    end
    
    return oxOptions
end

--- Convert universal options to qb-menu format
---@param options table Universal options
---@param menuId string Menu ID for back navigation
---@return table qbOptions
local function ConvertToQBOptions(options, menuId)
    local qbOptions = {}
    
    for _, opt in ipairs(options) do
        local qbOpt = {
            header = opt.title,
            txt = opt.description or '',
            icon = opt.icon,
            isMenuHeader = opt.disabled,
            params = {}
        }
        
        if opt.onSelect then
            qbOpt.params.event = 'rpa-lib:menu:callback'
            qbOpt.params.args = {
                menuId = menuId,
                callback = opt.onSelect,
                args = opt.args
            }
        elseif opt.menu then
            qbOpt.params.event = 'rpa-lib:menu:open'
            qbOpt.params.args = { menuId = opt.menu }
        elseif opt.serverEvent then
            qbOpt.params.isServer = true
            qbOpt.params.event = opt.serverEvent
            qbOpt.params.args = opt.args
        elseif opt.clientEvent then
            qbOpt.params.event = opt.clientEvent
            qbOpt.params.args = opt.args
        end
        
        table.insert(qbOptions, qbOpt)
    end
    
    return qbOptions
end

--- Open a registered menu
---@param menuId string Menu ID to open
local function OpenMenu(menuId)
    if not MenuType then return false end
    
    if MenuType == 'ox_lib' then
        lib.showContext(menuId)
        return true
    elseif MenuType == 'qb-menu' then
        local menuData = OpenMenus[menuId]
        if not menuData then return false end
        
        exports['qb-menu']:openMenu(ConvertToQBOptions(menuData.options, menuId))
        return true
    end
    
    return false
end

--- Show an input dialog
---@param title string Dialog title
---@param inputs table Array of input definitions
---@return table|nil results Input values or nil if cancelled
local function InputDialog(title, inputs)
    if not MenuType then return nil end
    
    if MenuType == 'ox_lib' then
        return lib.inputDialog(title, inputs)
    elseif MenuType == 'qb-menu' then
        -- QB-Core doesn't have native input dialogs, use ox_lib if available
        if GetResourceState('ox_lib') == 'started' then
            return lib.inputDialog(title, inputs)
        end
        return nil
    end
    
    return nil
end

--- Show a confirmation dialog
---@param title string Dialog title
---@param content string Dialog content/description
---@return boolean confirmed
local function ConfirmDialog(title, content)
    if not MenuType then return false end
    
    if MenuType == 'ox_lib' then
        local result = lib.alertDialog({
            header = title,
            content = content,
            centered = true,
            cancel = true
        })
        return result == 'confirm'
    elseif MenuType == 'qb-menu' then
        -- Fallback: just return true (no native confirm in qb-menu)
        return true
    end
    
    return false
end

--- Show a progress bar
---@param options table Progress options { duration, label, useWhileDead, canCancel, etc. }
---@return boolean completed
local function ProgressBar(options)
    if GetResourceState('ox_lib') == 'started' then
        return lib.progressBar({
            duration = options.duration or 1000,
            label = options.label or 'Loading...',
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel or false,
            disable = options.disable or { car = true, move = true, combat = true },
            anim = options.anim,
            prop = options.prop
        })
    elseif GetResourceState('progressbar') == 'started' then
        -- QB-Core progressbar
        local finished = false
        local success = false
        
        exports['progressbar']:Progress({
            name = options.name or 'rpa_progress',
            duration = options.duration or 1000,
            label = options.label or 'Loading...',
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel or false,
            controlDisables = options.disable or { disableMovement = true, disableCarMovement = true, disableCombat = true },
            animation = options.anim,
            prop = options.prop
        }, function(cancelled)
            finished = true
            success = not cancelled
        end)
        
        while not finished do Wait(10) end
        return success
    end
    
    -- Fallback: just wait
    Wait(options.duration or 1000)
    return true
end

--- Close any open menu
local function CloseMenu()
    if MenuType == 'ox_lib' then
        lib.hideContext()
    elseif MenuType == 'qb-menu' then
        exports['qb-menu']:closeMenu()
    end
end

--- Show a list selection dialog
---@param title string Dialog title
---@param options table Array of { value, label, description?, icon? }
---@return any|nil selected Selected value or nil
local function SelectList(title, options)
    if GetResourceState('ox_lib') ~= 'started' then return nil end
    
    local oxOptions = {}
    for _, opt in ipairs(options) do
        table.insert(oxOptions, {
            value = opt.value,
            label = opt.label,
            description = opt.description,
            icon = opt.icon
        })
    end
    
    return lib.inputDialog(title, {
        { type = 'select', label = 'Select', options = oxOptions, required = true }
    })
end

--- Get color picker input
---@param title string Dialog title
---@param defaultColor table|nil { r, g, b } default color
---@return table|nil color { r, g, b } or nil
local function ColorPicker(title, defaultColor)
    if GetResourceState('ox_lib') ~= 'started' then return nil end
    
    local result = lib.inputDialog(title, {
        { type = 'number', label = 'Red (0-255)', default = defaultColor and defaultColor.r or 255, min = 0, max = 255 },
        { type = 'number', label = 'Green (0-255)', default = defaultColor and defaultColor.g or 255, min = 0, max = 255 },
        { type = 'number', label = 'Blue (0-255)', default = defaultColor and defaultColor.b or 255, min = 0, max = 255 },
    })
    
    if result then
        return { r = result[1], g = result[2], b = result[3] }
    end
    return nil
end

--- Get coordinates input (current position or manual)
---@param title string Dialog title
---@param useCurrentPos boolean Whether to offer current position option
---@return vector3|nil coords
local function CoordsInput(title, useCurrentPos)
    if GetResourceState('ox_lib') ~= 'started' then return nil end
    
    local ped = PlayerPedId()
    local currentCoords = GetEntityCoords(ped)
    
    if useCurrentPos then
        local choice = lib.inputDialog(title, {
            { 
                type = 'select', 
                label = 'Position', 
                options = {
                    { value = 'current', label = 'Use Current Position' },
                    { value = 'manual', label = 'Enter Manually' }
                },
                required = true
            }
        })
        
        if not choice then return nil end
        
        if choice[1] == 'current' then
            return currentCoords
        end
    end
    
    local result = lib.inputDialog(title .. ' - Enter Coordinates', {
        { type = 'number', label = 'X', default = currentCoords.x },
        { type = 'number', label = 'Y', default = currentCoords.y },
        { type = 'number', label = 'Z', default = currentCoords.z },
    })
    
    if result then
        return vector3(result[1], result[2], result[3])
    end
    return nil
end

-- Event handlers for qb-menu callbacks
RegisterNetEvent('rpa-lib:menu:callback', function(data)
    if data.callback then
        data.callback(data.args)
    end
end)

RegisterNetEvent('rpa-lib:menu:open', function(data)
    OpenMenu(data.menuId)
end)

-- Exports
exports('GetMenuType', GetMenuType)
exports('RegisterMenu', RegisterMenu)
exports('OpenMenu', OpenMenu)
exports('CloseMenu', CloseMenu)
exports('InputDialog', InputDialog)
exports('ConfirmDialog', ConfirmDialog)
exports('ProgressBar', ProgressBar)
exports('SelectList', SelectList)
exports('ColorPicker', ColorPicker)
exports('CoordsInput', CoordsInput)

print('[rpa-lib] Menu utilities loaded')
