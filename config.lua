Config = {}

-- Debug mode for development
Config.Debug = false

-- Target system to use: 'ox_target', 'qb-target', 'qtarget'
-- Will auto-detect if not specified
Config.TargetSystem = nil

-- Notification system to use: 'rpa-notify', 'ox_lib', 'qb-core'
-- Will auto-detect if not specified
Config.NotifySystem = nil

-- TextUI system to use: 'rpa-textui', 'ox_lib', 'qb-core'
-- Will auto-detect if not specified
Config.TextUISystem = nil

-- Default notification duration (ms)
Config.NotifyDuration = 5000

--[[
    ==========================================
    PERMISSIONS SYSTEM CONFIGURATION
    ==========================================
    
    RP-Alpha supports two permission methods that work together:
    
    1. QB-Core/QBOX Groups (defined in qb-core/shared/main.lua)
       - Examples: 'admin', 'god', 'mod', 'dev', 'user'
    
    2. Server.cfg ConVar-based IDs (like Jaksam scripts)
       Add these to your server.cfg:
       
       # Global RP-Alpha permissions
       setr rpa:admins "steam:110000123456789,license:abc123def456"
       setr rpa:mods "steam:110000987654321,license:xyz789"
       setr rpa:devs "steam:110000111111111"
       
       # Resource-specific permissions
       setr rpa_police:manage_ranks "steam:123456,license:abcdef"
       setr rpa_mdt:view_all_records "steam:789012"
       setr rpa_ambulance:revive_anyone "license:ghijkl"
       
    How to find player identifiers:
    - Use /checkperms [playerID] command in-game (admin only)
    - Check server console for player connection logs
    - Steam ID format: steam:110000xxxxxxxxx
    - License format: license:xxxxxxxxxxxxxxxx
    - Discord format: discord:xxxxxxxxxxxxxxxxxx
]]

-- Default admin groups (QB-Core/QBOX)
Config.AdminGroups = {'admin', 'god', 'superadmin'}

-- Default moderator groups
Config.ModGroups = {'mod', 'moderator'}

-- Default developer groups  
Config.DevGroups = {'dev', 'developer'}
