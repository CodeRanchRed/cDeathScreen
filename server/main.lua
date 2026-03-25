local function FetchDiscordAvatar(src, cb)
    if not Config.DiscordBotToken or Config.DiscordBotToken == "" then
        return cb(Config.FallbackAvatarUrl)
    end

    local discordId = nil
    local numIds = GetNumPlayerIdentifiers(src)
    for i = 0, numIds - 1 do
        local id = GetPlayerIdentifier(src, i)
        if id and id:sub(1, 8) == "discord:" then
            discordId = id:gsub("^discord:", "")
            break
        end
    end

    if not discordId then
        return cb(Config.FallbackAvatarUrl)
    end

    local url = ("https://discord.com/api/v10/users/%s"):format(discordId)

    PerformHttpRequest(url, function(statusCode, body, headers)
        local avatarUrl = Config.FallbackAvatarUrl
        if statusCode == 200 and body then
            local ok, data = pcall(json.decode, body)
            if ok and data and data.id and data.avatar then
                avatarUrl = ("https://cdn.discordapp.com/avatars/%s/%s.png?size=128"):format(data.id, data.avatar)
            else
                cBase.Log(T("log_avatar_fail", src), "error")
            end
        else
            cBase.Log(T("log_avatar_http", tostring(statusCode), src), "error")
        end
        cb(avatarUrl)
    end, "GET", "", {
        ["Authorization"] = "Bot " .. Config.DiscordBotToken,
        ["Content-Type"] = "application/json"
    })
end

local function GetWeaponLabel(weaponHash)
    if not weaponHash or weaponHash == "Unknown" or weaponHash == "" then
        return T("unknown")
    end
    local str = tostring(weaponHash):upper()
    if Config.WeaponLabels[str] then
        return Config.WeaponLabels[str]
    end
    local clean = str:gsub("^WEAPON_", ""):gsub("_", " ")
    clean = clean:sub(1, 1):upper() .. clean:sub(2):lower()
    if clean == "Fall / Unknown" then
        return T("fall_damage")
    end
    return clean
end

local function GetNearestHospital(pos)
    local best, bestDist = Config.HospitalSpawns[1], math.huge
    for _, h in ipairs(Config.HospitalSpawns) do
        local dx = h.x - pos.x
        local dy = h.y - pos.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < bestDist then
            bestDist = dist
            best = h
        end
    end
    return best
end

local function GetCharName(src)
    if not src or src <= 0 then
        return T("unknown")
    end
    local ok, name = pcall(cBase.GetUserFullName, src)
    if ok and name and name ~= "" then
        return name
    end
    return T("unknown")
end

local deathSessions = {}
RegisterNetEvent("deathscreen:playerDied")
AddEventHandler("deathscreen:playerDied", function(params)
    local src = source
    local killerSrc = tonumber(params.killerSrc) or 0
    local weaponHash = params.weaponHash or T("unknown")
    local location = params.location or ""
    local deathPos = params.deathPos or {
        x = 0,
        y = 0,
        z = 0
    }
    local timeOfDeath = params.timeOfDeath or os.date("%I:%M %p")
    local distance = params.distance or "?"

    local killerName
    if killerSrc > 0 then
        killerName = GetCharName(killerSrc)
    else
        killerName = params.killerName or T("the_world")
    end

    local deathType = GetWeaponLabel(weaponHash)
    local victimName = GetCharName(src)

    deathSessions[src] = {
        killerName = killerName,
        deathType = deathType,
        location = location,
        deathPos = deathPos,
        timeStr = timeOfDeath,
        hospital = GetNearestHospital(deathPos)
    }

    cBase.Log(T("log_died", victimName, killerName, deathType, location), "success")

    if Config.LogDeaths then
        pcall(function()
            exports["cBase"]:SendLog(Config.DeathLogWebhook, T("embed_died_title", victimName), "red", "Player Death",
                {{
                    name = T("embed_victim"),
                    value = victimName,
                    inline = true
                }, {
                    name = T("embed_killer"),
                    value = killerName,
                    inline = true
                }, {
                    name = T("embed_weapon"),
                    value = deathType,
                    inline = true
                }, {
                    name = T("embed_location"),
                    value = location,
                    inline = true
                }, {
                    name = T("embed_time"),
                    value = timeOfDeath,
                    inline = true
                }, {
                    name = T("embed_distance"),
                    value = distance,
                    inline = true
                }})
        end)
    end

    FetchDiscordAvatar(src, function(avatarUrl)
        TriggerClientEvent("deathscreen:openScreen", src, {
            killerName = killerName,
            deathType = deathType,
            location = location,
            timeOfDeath = timeOfDeath,
            distance = distance,
            avatarUrl = avatarUrl,
            locale = TUI()
        })
    end)
end)

RegisterNetEvent("deathscreen:requestRespawn")
AddEventHandler("deathscreen:requestRespawn", function()
    local src = source
    local session = deathSessions[src]

    if not session then
        cBase.Log(T("log_session_miss", src), "error")
        TriggerClientEvent("deathscreen:doRespawn", src, nil)
        return
    end

    local spawnPos
    if Config.RespawnAtHospital then
        spawnPos = session.hospital
    else
        spawnPos = {
            x = session.deathPos.x,
            y = session.deathPos.y,
            z = session.deathPos.z,
            h = 0.0
        }
    end

    local victimName = GetCharName(src)
    deathSessions[src] = nil

    cBase.RevivePlayer(src)

    if Config.LogRespawns then
        pcall(function()
            exports["cBase"]:SendLog(Config.DeathLogWebhook, T("embed_respawn_title", victimName), "green",
                "Player Respawn", {{
                    name = T("embed_player"),
                    value = victimName,
                    inline = true
                }, {
                    name = T("embed_spawn_loc"),
                    value = spawnPos.label or T("death_site"),
                    inline = true
                }})
        end)
    end

    cBase.Log(T("log_respawned", victimName, spawnPos.label or "?", spawnPos.x, spawnPos.y), "success")
    TriggerClientEvent("deathscreen:doRespawn", src, spawnPos)
end)

RegisterNetEvent("deathscreen:callForHelp")
AddEventHandler("deathscreen:callForHelp", function(params)
    local src = source
    if not Config.AllowCallForHelp then
        return
    end

    local callerName = GetCharName(src)
    local location = params.location or T("unknown")
    local callerPos = params.callerPos or {
        x = 0,
        y = 0,
        z = 0
    }
    local notified = 0

    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if pid ~= src then
            local ped = GetPlayerPed(pid)
            if ped and ped ~= 0 then
                local px, py = table.unpack(GetEntityCoords(ped))
                local dx = px - callerPos.x
                local dy = py - callerPos.y
                if math.sqrt(dx * dx + dy * dy) <= Config.CallForHelpRadius then
                    cBase.SendNotification(pid, T("nearby_help_alert", callerName, location), "error", 8000)
                    notified = notified + 1
                end
            end
        end
    end

    cBase.Log(T("log_call_help", callerName, notified))
    TriggerClientEvent("deathscreen:callForHelpResult", src, {
        sent = true,
        notified = notified
    })
end)

AddEventHandler("playerDropped", function()
    deathSessions[source] = nil
end)

local function OnFrameworkDeath(src, isDeadFlag)
    if isDeadFlag == false then
        return
    end
    if deathSessions[src] then
        return
    end
    if not cBase.IsPlayerDead(src) then
        return
    end

    cBase.Log(T("log_framework_hook", src, tostring(cBase.framework)), "success")

    local ped = GetPlayerPed(src)
    local px, py, pz = 0.0, 0.0, 0.0
    if ped and ped ~= 0 then
        px, py, pz = table.unpack(GetEntityCoords(ped))
    end
    local pos = {
        x = px,
        y = py,
        z = pz
    }
    local timeStr = os.date("%I:%M %p")

    deathSessions[src] = {
        killerName = T("unknown"),
        deathType = T("unknown"),
        location = T("unknown"),
        deathPos = pos,
        timeStr = timeStr,
        hospital = GetNearestHospital(pos)
    }

    FetchDiscordAvatar(src, function(avatarUrl)
        TriggerClientEvent("deathscreen:forceOpen", src, {
            killerName = T("unknown"),
            deathType = T("unknown"),
            location = T("unknown"),
            timeOfDeath = timeStr,
            distance = "?",
            avatarUrl = avatarUrl,
            locale = TUI()
        })
    end)
end

AddEventHandler("vorpCore:playerDeath", function()
    if cBase.framework ~= "vorp" then
        return
    end
    OnFrameworkDeath(source, true)
end)

AddEventHandler("redemrp:playerDied", function()
    if cBase.framework ~= "redemrp" then
        return
    end
    OnFrameworkDeath(source, true)
end)

AddEventHandler("rsg-ambulancejob:server:SetDeathStatus", function(src, isDead)
    if cBase.framework ~= "rsg" then
        return
    end
    OnFrameworkDeath(src, isDead)
end)

AddEventHandler("qbrcore:server:setDeadStatus", function(src, isDead)
    if cBase.framework ~= "qbrcore" then
        return
    end
    OnFrameworkDeath(src, isDead)
end)

AddEventHandler("vorp_core:Server:OnPlayerRevive", function(src)
    if not deathSessions[src] then
        return
    end
    local session = deathSessions[src]
    local spawnPos = session.hospital or Config.HospitalSpawns[1]
    deathSessions[src] = nil
    TriggerClientEvent("deathscreen:externalRevive", src, spawnPos)
    cBase.Log(T("log_external_revive", src, spawnPos.label or "?"), "success")
end)

RegisterNetEvent("hospital:server:RevivePlayer")
AddEventHandler("hospital:server:RevivePlayer", function(targetSrc)
    local src = source
    if not deathSessions[targetSrc] then
        return
    end
    local session = deathSessions[targetSrc]
    local spawnPos = session.hospital or Config.HospitalSpawns[1]
    deathSessions[targetSrc] = nil
    TriggerClientEvent("deathscreen:externalRevive", targetSrc, spawnPos)
    cBase.Log(T("log_medic_revive", src, targetSrc), "success")
end)

--- Returns true if the player currently has an active death session.
---@param src number  server source id
---@return boolean
exports("IsPlayerDead", function(src)
    return deathSessions[src] ~= nil
end)

--- Programmatically revive a player and teleport them to an optional position.
--- Clears the death session and triggers the client respawn sequence.
---@param src     number              server source id
---@param spawnPos table|nil          { x, y, z, h } — falls back to nearest hospital
exports("RevivePlayer", function(src, spawnPos)
    local session = deathSessions[src]
    if not session then
        return
    end

    local pos = spawnPos or session.hospital or Config.HospitalSpawns[1]
    deathSessions[src] = nil
    cBase.RevivePlayer(src)
    TriggerClientEvent("deathscreen:externalRevive", src, pos)
    cBase.Log(T("log_external_revive", src, pos.label or "export"), "success")
end)

--- Force-open the death screen for a player without them actually dying in-world.
--- Useful for frameworks that manage death state externally (e.g. QBCore down-state).
---@param src  number   server source id
---@param data table    { killerName, deathType, location, timeOfDeath, distance }
exports("ForceOpenScreen", function(src, data)
    if deathSessions[src] then
        return
    end

    local ped = GetPlayerPed(src)
    local px, py, pz = 0.0, 0.0, 0.0
    if ped and ped ~= 0 then
        px, py, pz = table.unpack(GetEntityCoords(ped))
    end
    local pos = {
        x = px,
        y = py,
        z = pz
    }
    local timeStr = data.timeOfDeath or os.date("%I:%M %p")

    deathSessions[src] = {
        killerName = data.killerName or T("unknown"),
        deathType = data.deathType or T("unknown"),
        location = data.location or T("unknown"),
        deathPos = pos,
        timeStr = timeStr,
        hospital = GetNearestHospital(pos)
    }

    FetchDiscordAvatar(src, function(avatarUrl)
        TriggerClientEvent("deathscreen:forceOpen", src, {
            killerName = data.killerName or T("unknown"),
            deathType = data.deathType or T("unknown"),
            location = data.location or T("unknown"),
            timeOfDeath = timeStr,
            distance = data.distance or "?",
            avatarUrl = avatarUrl,
            locale = TUI()
        })
    end)
end)

--- Returns a copy of the active death session for a player, or nil.
---@param src number
---@return table|nil  { killerName, deathType, location, deathPos, hospital, timeStr }
exports("GetDeathSession", function(src)
    local s = deathSessions[src]
    if not s then
        return nil
    end
    return {
        killerName = s.killerName,
        deathType = s.deathType,
        location = s.location,
        deathPos = s.deathPos,
        hospital = s.hospital,
        timeStr = s.timeStr
    }
end)
