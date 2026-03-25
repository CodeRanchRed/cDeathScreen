local isDead = false
local isScreenOpen = false
local respawnTriggered = false
local callHelpCooldown = false
local infoPanelOpen = false

local ZONES = Config.Zones

local function GetLocationName(x, y)
    local best, bestDist = T("unknown"), math.huge
    for _, zone in ipairs(ZONES) do
        local dx = zone.x - x
        local dy = zone.y - y
        local d = dx * dx + dy * dy
        if d < bestDist then
            bestDist = d
            best = zone.name
        end
    end
    return best
end

local function GetGameTime()
    local h = GetClockHours()
    local m = GetClockMinutes()
    local suffix = h >= 12 and "PM" or "AM"
    if h > 12 then
        h = h - 12
    elseif h == 0 then
        h = 12
    end
    return ("%d:%02d %s"):format(h, m, suffix)
end

local function WeaponHashToString(hash)
    if not hash or hash == 0 then
        return T("fall_damage")
    end
    for key in pairs(Config.WeaponLabels) do
        if GetHashKey(key) == hash then
            return key
        end
    end
    return string.format("0x%08X", hash)
end

local function OpenDeathScreen(data)
    isScreenOpen = true
    infoPanelOpen = false
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        type = "showDeath",
        killerName = data.killerName or T("unknown"),
        deathType = data.deathType or T("unknown"),
        location = data.location or "",
        time = data.timeOfDeath or GetGameTime(),
        distance = data.distance or "?",
        avatar = data.avatarUrl or Config.FallbackAvatarUrl
    })
end

local function CloseDeathScreen()
    isScreenOpen = false
    infoPanelOpen = false
    SendNUIMessage({
        type = "hideDeath"
    })
end

local function SetInfoPanel(open)
    infoPanelOpen = open
    SendNUIMessage({
        type = "setInfoPanel",
        open = open
    })
end

local function DoRespawn(spawnPos)
    spawnPos = spawnPos or {
        x = -280.84,
        y = 802.85,
        z = 118.71,
        h = 250.0
    }

    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Citizen.Wait(600)

    NetworkResurrectLocalPlayer(spawnPos.x, spawnPos.y, spawnPos.z, spawnPos.h, true, false)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
    ClearPedTasksImmediately(ped)
    SetEntityCoords(ped, spawnPos.x, spawnPos.y, spawnPos.z, false, false, false, false)
    SetEntityHeading(ped, spawnPos.h or 0.0)

    Citizen.Wait(300)
    DoScreenFadeIn(800)

    isDead = false
    respawnTriggered = false
    CloseDeathScreen()

    cBase.SendNotification(T("revived"), "success", 5000)
end

local function TriggerRespawn()
    if respawnTriggered then
        return
    end
    respawnTriggered = true
    TriggerServerEvent("deathscreen:requestRespawn")
end

local function OnPlayerDied(killerEntity, weaponHash, deathX, deathY, deathZ)
    if isDead then
        return
    end
    isDead = true
    respawnTriggered = false

    local location = GetLocationName(deathX, deathY)
    local timeStr = GetGameTime()
    local killerSrc = 0
    local killerName = T("the_world")
    local distanceStr = "?"

    if killerEntity and killerEntity ~= 0 and DoesEntityExist(killerEntity) then
        local kx, ky, kz = table.unpack(GetEntityCoords(killerEntity))
        local dist = #(vector3(deathX, deathY, deathZ) - vector3(kx, ky, kz))
        distanceStr = math.floor(dist + 0.5) .. "m"

        if IsEntityAPed(killerEntity) then
            if IsPedAPlayer(killerEntity) then
                killerSrc = NetworkGetEntityOwner(killerEntity)
            else
                local model = GetEntityModel(killerEntity)
                killerName = GetLabelText(GetDisplayNameFromVehicleModel(model)) or T("unknown_npc")
            end
        end
    end

    local weaponStr = WeaponHashToString(weaponHash)

    TriggerServerEvent("deathscreen:playerDied", {
        killerSrc = killerSrc,
        killerName = killerName,
        weaponHash = weaponStr,
        location = location,
        deathPos = {
            x = deathX,
            y = deathY,
            z = deathZ
        },
        timeOfDeath = timeStr,
        distance = distanceStr
    })

    Citizen.SetTimeout(Config.DeathTimerDuration, function()
        if isDead and not respawnTriggered then
            TriggerRespawn()
        end
    end)
end

RegisterNetEvent("deathscreen:openScreen")
AddEventHandler("deathscreen:openScreen", function(res)
    OpenDeathScreen(res)
end)

RegisterNetEvent("deathscreen:doRespawn")
AddEventHandler("deathscreen:doRespawn", function(spawnPos)
    DoRespawn(spawnPos)
end)

RegisterNetEvent("deathscreen:callForHelpResult")
AddEventHandler("deathscreen:callForHelpResult", function(res)
    if res and res.sent then
        cBase.SendNotification(T("help_sent", res.notified or 0), "success", 4000)
    else
        cBase.SendNotification(T("help_failed"), "error", 3000)
    end
end)

RegisterNetEvent("deathscreen:forceOpen")
AddEventHandler("deathscreen:forceOpen", function(data)
    if isDead and isScreenOpen then
        return
    end
    isDead = true
    respawnTriggered = false
    OpenDeathScreen(data)
    Citizen.SetTimeout(Config.DeathTimerDuration, function()
        if isDead and not respawnTriggered then
            TriggerRespawn()
        end
    end)
end)

RegisterNetEvent("deathscreen:externalRevive")
AddEventHandler("deathscreen:externalRevive", function(spawnPos)
    if not isDead then
        return
    end
    DoRespawn(spawnPos)
end)

Citizen.CreateThread(function()
    local wasAlive = true
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local alive = health > Config.DeadHealthThreshold

        if wasAlive and not alive and not isDead then
            local weaponHash = GetPedCauseOfDeath(ped) or 0
            local killerEntity = 0

            if HasEntityBeenDamagedByAnyPed(ped) then
                local handle, nearPed = FindFirstPed()
                local more = true
                while more do
                    if nearPed ~= ped and DoesEntityExist(nearPed) and HasEntityBeenDamagedByEntity(ped, nearPed, true) then
                        killerEntity = nearPed
                        more = false
                    else
                        more, nearPed = FindNextPed(handle)
                    end
                end
                EndFindPed(handle)
            end

            local px, py, pz = table.unpack(GetEntityCoords(ped))
            ClearEntityLastDamageEntity(ped)
            OnPlayerDied(killerEntity, weaponHash, px, py, pz)
            wasAlive = false

        elseif not wasAlive and alive then
            if isDead then
                isDead = false
                respawnTriggered = false
                CloseDeathScreen()
            end
            wasAlive = true
        end

        Citizen.Wait(alive and 500 or 100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isDead and isScreenOpen then

            -- J — toggle info panel
            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.Keys.InfoPanel) then
                SetInfoPanel(not infoPanelOpen)
            end

            -- F — respawn
            if not respawnTriggered and Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.Keys.Respawn) then
                TriggerRespawn()
            end

            -- T — call for help
            if Config.AllowCallForHelp and not callHelpCooldown and
                Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.Keys.CallForHelp) then
                callHelpCooldown = true
                local ped = PlayerPedId()
                local px, py, pz = table.unpack(GetEntityCoords(ped))
                TriggerServerEvent("deathscreen:callForHelp", {
                    callerPos = {
                        x = px,
                        y = py,
                        z = pz
                    },
                    location = GetLocationName(px, py)
                })
                Citizen.SetTimeout(Config.CallForHelpCooldown * 1000, function()
                    callHelpCooldown = false
                end)
            end

        end
    end
end)

RegisterNUICallback("deathscreen:timerExpired", function(_, cb)
    cb({})
    if isDead and not respawnTriggered then
        TriggerRespawn()
    end
end)

RegisterNUICallback("deathscreen:respawnClicked", function(_, cb)
    cb({})
    if isDead and not respawnTriggered then
        TriggerRespawn()
    end
end)

--- Returns whether the local player is currently in a dead state.
---@return boolean
exports("IsDead", function()
    return isDead
end)

--- Returns whether the death screen UI is currently visible.
---@return boolean
exports("IsScreenOpen", function()
    return isScreenOpen
end)

--- Manually open the death screen with custom data (no server round-trip).
--- Useful for preview / UI testing, or client-side framework hooks.
---@param data table  { killerName, deathType, location, time, distance, avatar }
exports("OpenScreen", function(data)
    OpenDeathScreen(data)
end)

--- Forcefully close and hide the death screen without triggering a respawn.
exports("CloseScreen", function()
    CloseDeathScreen()
end)
