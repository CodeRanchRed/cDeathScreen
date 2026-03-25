Config = Config or {}
Config.Keys = Config.Keys or {}

-- -----------------------------------------------------------------------
-- Death timer: how long (ms) before auto-respawn fires.
-- Must match timerDuration in the Vue component (default 30 s).
-- -----------------------------------------------------------------------
Config.DeathTimerDuration = 30000

-- -----------------------------------------------------------------------
-- Keybind hashes
-- -----------------------------------------------------------------------
Config.Keys = {
    InfoPanel   = 0xF3830D8E,   -- J
    Respawn     = 0xB2F377E8,   -- F
    CallForHelp = 0x9720FCEE,   -- T
}

-- -----------------------------------------------------------------------
-- Call-for-help settings
-- -----------------------------------------------------------------------
Config.AllowCallForHelp    = true
Config.CallForHelpRadius   = 200.0   -- game units
Config.CallForHelpCooldown = 30      -- seconds between calls (per player)

-- -----------------------------------------------------------------------
-- Respawn destination
-- true  = nearest hospital spawn below
-- false = exact death position
-- -----------------------------------------------------------------------
Config.RespawnAtHospital = true

-- -----------------------------------------------------------------------
-- Hospital / medical spawn points
-- Coordinates sourced from community RDR2 map data (BlipMap / GTABase).
-- Each entry: x, y, z = spawn position; h = heading (0-360); label = name.
-- -----------------------------------------------------------------------
Config.HospitalSpawns = {
    {   -- Valentine Doctor's Office
        x = -275.79, y = 796.54, z = 118.47,
        h = 250.0,
        label = "Valentine Doctor",
    },
    {   -- Rhodes Doctor's Office
        x = 1221.07, y = -1326.83, z = 90.47,
        h = 90.0,
        label = "Rhodes Doctor",
    },
    {   -- Annesburg Doctor's Office
        x = 2941.78, y = 1388.11, z = 43.97,
        h = 180.0,
        label = "Annesburg Doctor",
    },
    {   -- Strawberry Doctor's Office
        x = -1779.02, y = -397.01, z = 155.79,
        h = 120.0,
        label = "Strawberry Doctor",
    },
    {   -- Saint Denis Doctor / Hospital (Algernon's area)
        x = 2571.22, y = -414.08, z = 43.63,
        h = 270.0,
        label = "Saint Denis Doctor",
    },
    {   -- Blackwater Doctor's Office
        x = -814.12, y = -1301.44, z = 43.67,
        h = 310.0,
        label = "Blackwater Doctor",
    },
    {   -- Armadillo (Tumbleweed area / Del Lobo territory)
        x = -3642.15, y = -2631.10, z = -13.10,
        h = 0.0,
        label = "Armadillo Doctor",
    },
}

-- -----------------------------------------------------------------------
-- Named map zones (used for death-location label)
-- Centre-point coordinates taken from in-game region data / community maps.
-- -----------------------------------------------------------------------
Config.Zones = {
    { name = "Annesburg",       x =  2900,  y =  1300  },
    { name = "Valentine",       x =  -270,  y =   790  },
    { name = "Rhodes",          x =  1250,  y = -1310  },
    { name = "Saint Denis",     x =  2470,  y =  -360  },
    { name = "Strawberry",      x = -1800,  y =  -380  },
    { name = "Blackwater",      x =  -820,  y = -1310  },
    { name = "Armadillo",       x = -3640,  y = -2620  },
    { name = "Tumbleweed",      x = -5430,  y = -2920  },
    { name = "Emerald Ranch",   x =   355,  y =   790  },
    { name = "Flat Iron Lake",  x = -1640,  y =  -400  },
    { name = "Tall Trees",      x = -1320,  y =  -350  },
    { name = "Great Plains",    x =  -400,  y =  -870  },
    { name = "Bluewater Marsh", x =  2100,  y =   570  },
    { name = "Roanoke Ridge",   x =  2680,  y =   690  },
    { name = "Scarlett Meadows",x =   860,  y =  -790  },
    { name = "Lemoyne",         x =  1480,  y =  -900  },
    { name = "New Hanover",     x =   790,  y =   760  },
    { name = "West Elizabeth",  x =  -760,  y = -1070  },
    { name = "Bayou Nwa",       x =  2160,  y =  -260  },
    { name = "Grizzlies West",  x =   180,  y =  1870  },
    { name = "Grizzlies East",  x =  2010,  y =  1850  },
    { name = "Ambarino",        x =   900,  y =  1470  },
    { name = "Cholla Springs",  x = -3200,  y = -2400  },
    { name = "Hennigan's Stead",x = -1420,  y = -1640  },
    { name = "Río Bravo",       x = -3700,  y = -3100  },
    { name = "Gaptooth Ridge",  x = -4800,  y = -3000  },
}

-- -----------------------------------------------------------------------
-- Health at or below which the client treats the player as dead.
-- RDR3 health range: 0–200. Keep ≤ 10 to avoid false positives.
-- -----------------------------------------------------------------------
Config.DeadHealthThreshold = 10

-- -----------------------------------------------------------------------
-- Discord integration
-- Set DiscordBotToken to "" to disable avatar fetching. its inside shared/sv_config.lua
-- -----------------------------------------------------------------------
Config.FallbackAvatarUrl = "https://i.pravatar.cc/128?img=8"

-- -----------------------------------------------------------------------
-- Weapon hash → friendly display label
-- Hashes not listed here are auto-formatted: WEAPON_RIFLE_BOLT → "Rifle bolt"
-- -----------------------------------------------------------------------
Config.WeaponLabels = {
    ["WEAPON_UNARMED"]              = "Fists",
    ["WEAPON_KNIFE"]                = "Knife",
    ["WEAPON_LANTERN"]              = "Lantern",
    ["WEAPON_TORCH"]                = "Torch",
    ["WEAPON_REVOLVER_CATTLEMAN"]   = "Cattleman Revolver",
    ["WEAPON_REVOLVER_DOUBLE"]      = "Double-Action Revolver",
    ["WEAPON_REVOLVER_SCHOFIELD"]   = "Schofield Revolver",
    ["WEAPON_PISTOL_MAUSER"]        = "Mauser Pistol",
    ["WEAPON_PISTOL_SEMIAUTO"]      = "Semi-Auto Pistol",
    ["WEAPON_REPEATER_CARBINE"]     = "Carbine Repeater",
    ["WEAPON_REPEATER_WINCHESTER"]  = "Winchester Repeater",
    ["WEAPON_REPEATER_HENRY"]       = "Henry Repeater",
    ["WEAPON_RIFLE_SPRINGFIELD"]    = "Springfield Rifle",
    ["WEAPON_RIFLE_BOLT"]           = "Bolt Action Rifle",
    ["WEAPON_RIFLE_VARMINT"]        = "Varmint Rifle",
    ["WEAPON_SHOTGUN_DOUBLEBARREL"] = "Double-Barrel Shotgun",
    ["WEAPON_SHOTGUN_PUMP"]         = "Pump Shotgun",
    ["WEAPON_SHOTGUN_SEMIAUTO"]     = "Semi-Auto Shotgun",
    ["WEAPON_BOW"]                  = "Bow",
    ["WEAPON_LASSO"]                = "Lasso",
    ["WEAPON_DYNAMITE"]             = "Dynamite",
    ["WEAPON_MOLOTOV"]              = "Molotov Cocktail",
    ["WEAPON_THROWING_KNIVES"]      = "Throwing Knives",
    ["WEAPON_TOMAHAWK"]             = "Tomahawk",
    ["WEAPON_HATCHET"]              = "Hatchet",
    ["WEAPON_MACHETE"]              = "Machete",
    ["WEAPON_HORSE"]                = "Horse",
    ["WEAPON_ANIMAL"]               = "Animal",
    ["WEAPON_FALL"]                 = "Fall Damage",
    ["WEAPON_DROWN"]                = "Drowning",
    ["WEAPON_FIRE"]                 = "Fire",
    ["WEAPON_EXPLOSION"]            = "Explosion",
    ["WEAPON_DROWNING"]             = "Drowning",
}

-- -----------------------------------------------------------------------
-- Discord logging
-- -----------------------------------------------------------------------
Config.DeathLogWebhook = "deaths"   -- key in cBase Config.DiscordLog.Webhooks
Config.LogDeaths       = true
Config.LogRespawns     = false