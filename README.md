![Image](https://r2.fivemanage.com/3pSHYKCq3Kasp2MONtlM5/TebexPackageImageYoutubeBannerImage-2.png)

[Preview](https://youtu.be/badD8kFPZ1k)
# cDeathScreen Documentation

## Requirements

- [cBase](https://github.com/CodeRanchRed/cBase) — must start before cDeathScreen
- A supported framework: VORP, RedemRP, RSG, QBRCore, or standalone

---

## Installation

1. Place `cBase` and `cDeathScreen` in your resources folder
2. In `server.cfg`:

```
ensure cBase
ensure cDeathScreen
```

3. Edit `cDeathScreen/config.lua` to your liking
4. Add your death webhook in `cBase/config.lua`:

```lua
Webhooks = {
    ["deaths"] = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
}
```

5. _(Optional)_ Add your Discord bot token in `cDeathScreen/shared/sv_config.lua` for avatar fetching:

```lua
Config.DiscordBotToken = "Bot YOUR_TOKEN_HERE"
```

---

### Keys (native input hashes)

| Action            | Default | Hash         |
| ----------------- | ------- | ------------ |
| Toggle info panel | J       | `0xF3830D8E` |
| Respawn           | F       | `0xB2F377E8` |
| Call for help     | T       | `0x9720FCEE` |

### Hospital Spawns

Each entry needs `x`, `y`, `z`, `h` (heading), and `label`. The nearest one to the death position is used.

### Map Zones

Each entry needs `name`, `x`, `y`. The closest zone centre to the death position is used as the location label.

---

## Exports

### Server — `exports["cDeathScreen"]`

```lua
-- Check if a player is downed
exports["cDeathScreen"]:IsPlayerDead(src)  --> boolean

-- Revive a player (spawnPos optional, falls back to nearest hospital)
exports["cDeathScreen"]:RevivePlayer(src, { x, y, z, h })

-- Force open the death screen without the player dying in-world
exports["cDeathScreen"]:ForceOpenScreen(src, {
    killerName = "Unknown",
    deathType  = "Fall Damage",
    location   = "Annesburg",
})

-- Read the current death session (returns nil if not downed)
local s = exports["cDeathScreen"]:GetDeathSession(src)
-- s.killerName, s.deathType, s.location, s.deathPos, s.hospital, s.timeStr
```

### Client — `exports["cDeathScreen"]`

```lua
exports["cDeathScreen"]:IsDead()       -- boolean
exports["cDeathScreen"]:IsScreenOpen() -- boolean
exports["cDeathScreen"]:OpenScreen({ killerName, deathType, location, time, distance })
exports["cDeathScreen"]:CloseScreen()
```

---

## Quick Integration Examples

**Gate an action while downed (client)**

```lua
if exports["cDeathScreen"]:IsDead() then return end
```

**Medic revive at a custom position (server)**

```lua
exports["cDeathScreen"]:RevivePlayer(targetSrc, {
    x = 1221.07, y = -1326.83, z = 90.47, h = 90.0
})
```

**Custom framework down-state (server)**

```lua
exports["cDeathScreen"]:ForceOpenScreen(src, {
    killerName = data.attacker,
    deathType  = data.cause,
    location   = data.area,
})
```
