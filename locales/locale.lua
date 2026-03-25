Locales = {}

Locales['en'] = {
    -- Notifications / system messages
    revived             = "You have been revived.",
    help_sent           = "Help sent! (%d nearby players notified)",
    help_failed         = "Could not send call for help.",

    -- Version checker (server console only)
    version_new         = "[%s] New Version Available!",
    version_current     = "Current Version: ",
    version_latest      = "Latest Version:  ",
    version_changelog   = "Changelog:",
    version_up_to_date  = "[cDeathScreen] You are using the latest version! (%s)",
    version_parse_fail  = "[cDeathScreen] Failed to parse version data!",
    version_http_fail   = "[cDeathScreen] Version check failed! (HTTP %s)",

    -- Server log strings (Discord / console)
    log_died            = "%s killed by %s (%s) at %s",
    log_respawned       = "%s respawned at %s (%.1f, %.1f)",
    log_call_help       = "%s called for help — %d players notified",
    log_session_miss    = "[DeathScreen] Respawn request from src %d with no active session",
    log_framework_hook  = "[DeathScreen] Framework hook: src %d died (%s)",
    log_external_revive = "[DeathScreen] External revive: src %d sent to %s",
    log_medic_revive    = "[DeathScreen] Medic revive: src %d revived src %d",
    log_avatar_fail     = "[DeathScreen] Discord avatar parse failed for src %d",
    log_avatar_http     = "[DeathScreen] Discord API failed (HTTP %s) for src %d",

    -- Discord embed field labels
    embed_victim        = "Victim",
    embed_killer        = "Killer",
    embed_weapon        = "Weapon",
    embed_location      = "Location",
    embed_time          = "Time",
    embed_distance      = "Distance",
    embed_died_title    = "%s has died.",
    embed_respawn_title = "%s has respawned.",
    embed_player        = "Player",
    embed_spawn_loc     = "Location",

    -- Fallback / unknown labels
    unknown             = "Unknown",
    the_world           = "The World",
    fall_damage         = "Fall Damage",
    unknown_npc         = "NPC",
    death_site          = "Death Site",

    -- Call-for-help notification sent to nearby players
    nearby_help_alert   = "[!] %s needs help near %s!",

    -- NUI / Vue UI strings (packed into the showDeath message)
    ui = {
        you_are          = "YOU ARE",
        dead             = "Dead!",
        info_btn         = "[J] Info",
        killed_by_prefix = "You were killed by",
        killed_by_mid    = "with a",
        killed_by_suffix = "weapon",
        time_label       = "Time",
        distance_label   = "Distance",
    },
}

Locales['tr'] = {
    revived             = "Canlandırıldınız.",
    help_sent           = "Yardım gönderildi! (%d yakın oyuncu bilgilendirildi)",
    help_failed         = "Yardım çağrısı gönderilemedi.",

    version_new         = "[%s] Yeni Sürüm Mevcut!",
    version_current     = "Mevcut Sürüm: ",
    version_latest      = "Son Sürüm:    ",
    version_changelog   = "Değişiklik Günlüğü:",
    version_up_to_date  = "[cDeathScreen] En son sürümü kullanıyorsunuz! (%s)",
    version_parse_fail  = "[cDeathScreen] Sürüm verisi ayrıştırılamadı!",
    version_http_fail   = "[cDeathScreen] Sürüm kontrolü başarısız! (HTTP %s)",

    log_died            = "%s, %s tarafından %s ile %s konumunda öldürüldü",
    log_respawned       = "%s, %s konumunda yeniden doğdu (%.1f, %.1f)",
    log_call_help       = "%s yardım çağırdı — %d oyuncu bilgilendirildi",
    log_session_miss    = "[DeathScreen] src %d için aktif oturum yok, yeniden doğma isteği alındı",
    log_framework_hook  = "[DeathScreen] Framework kancası: src %d öldü (%s)",
    log_external_revive = "[DeathScreen] Dış canlandırma: src %d, %s konumuna gönderildi",
    log_medic_revive    = "[DeathScreen] Doktor canlandırması: src %d, src %d'yi canlandırdı",
    log_avatar_fail     = "[DeathScreen] src %d için Discord avatar ayrıştırma başarısız",
    log_avatar_http     = "[DeathScreen] Discord API başarısız (HTTP %s), src %d",

    embed_victim        = "Kurban",
    embed_killer        = "Katil",
    embed_weapon        = "Silah",
    embed_location      = "Konum",
    embed_time          = "Zaman",
    embed_distance      = "Mesafe",
    embed_died_title    = "%s öldü.",
    embed_respawn_title = "%s yeniden doğdu.",
    embed_player        = "Oyuncu",
    embed_spawn_loc     = "Konum",

    unknown             = "Bilinmiyor",
    the_world           = "Dünya",
    fall_damage         = "Düşme Hasarı",
    unknown_npc         = "NPC",
    death_site          = "Ölüm Yeri",

    nearby_help_alert   = "[!] %s, %s yakınında yardıma ihtiyaç duyuyor!",

    ui = {
        you_are          = "SİZ",
        dead             = "Öldünüz!",
        info_btn         = "[J] Bilgi",
        killed_by_prefix = "Sizi",
        killed_by_mid    = "tarafından",
        killed_by_suffix = "silahıyla öldürüldünüz",
        time_label       = "Zaman",
        distance_label   = "Mesafe",
    },
}

Locales['ar'] = {
    revived             = "تمت إعادة إحيائك.",
    help_sent           = "تم إرسال الاستغاثة! (%d لاعبين قريبين تم إخطارهم)",
    help_failed         = "تعذّر إرسال نداء الاستغاثة.",

    version_new         = "[%s] إصدار جديد متاح!",
    version_current     = "الإصدار الحالي: ",
    version_latest      = "آخر إصدار:    ",
    version_changelog   = "سجل التغييرات:",
    version_up_to_date  = "[cDeathScreen] أنت تستخدم أحدث إصدار! (%s)",
    version_parse_fail  = "[cDeathScreen] فشل تحليل بيانات الإصدار!",
    version_http_fail   = "[cDeathScreen] فشل فحص الإصدار! (HTTP %s)",

    log_died            = "%s قُتل بواسطة %s (%s) في %s",
    log_respawned       = "%s أعيد إحياؤه في %s (%.1f, %.1f)",
    log_call_help       = "%s طلب المساعدة — تم إخطار %d لاعب",
    log_session_miss    = "[DeathScreen] طلب إعادة إحياء من src %d دون جلسة نشطة",
    log_framework_hook  = "[DeathScreen] ربط الإطار: src %d مات (%s)",
    log_external_revive = "[DeathScreen] إحياء خارجي: src %d أُرسل إلى %s",
    log_medic_revive    = "[DeathScreen] إحياء المسعف: src %d أحيا src %d",
    log_avatar_fail     = "[DeathScreen] فشل تحليل صورة Discord للاعب src %d",
    log_avatar_http     = "[DeathScreen] فشل Discord API (HTTP %s) للاعب src %d",

    embed_victim        = "الضحية",
    embed_killer        = "القاتل",
    embed_weapon        = "السلاح",
    embed_location      = "الموقع",
    embed_time          = "الوقت",
    embed_distance      = "المسافة",
    embed_died_title    = "%s مات.",
    embed_respawn_title = "%s أُعيد إحياؤه.",
    embed_player        = "اللاعب",
    embed_spawn_loc     = "الموقع",

    unknown             = "مجهول",
    the_world           = "العالم",
    fall_damage         = "ضرر السقوط",
    unknown_npc         = "شخصية ثانوية",
    death_site          = "موقع الوفاة",

    nearby_help_alert   = "[!] %s يحتاج مساعدة بالقرب من %s!",

    ui = {
        you_are          = "أنت",
        dead             = "ميت!",
        info_btn         = "[J] معلومات",
        killed_by_prefix = "لقد قُتلت على يد",
        killed_by_mid    = "باستخدام",
        killed_by_suffix = "سلاح",
        time_label       = "الوقت",
        distance_label   = "المسافة",
    },
}

Locales['fr'] = {
    revived             = "Vous avez été réanimé.",
    help_sent           = "Aide envoyée ! (%d joueurs proches notifiés)",
    help_failed         = "Impossible d'envoyer l'appel à l'aide.",

    version_new         = "[%s] Nouvelle version disponible !",
    version_current     = "Version actuelle : ",
    version_latest      = "Dernière version : ",
    version_changelog   = "Changelog :",
    version_up_to_date  = "[cDeathScreen] Vous utilisez la dernière version ! (%s)",
    version_parse_fail  = "[cDeathScreen] Impossible d'analyser les données de version !",
    version_http_fail   = "[cDeathScreen] Vérification de version échouée ! (HTTP %s)",

    log_died            = "%s tué par %s (%s) à %s",
    log_respawned       = "%s réapparu à %s (%.1f, %.1f)",
    log_call_help       = "%s a demandé de l'aide — %d joueurs notifiés",
    log_session_miss    = "[DeathScreen] Demande de réapparition de src %d sans session active",
    log_framework_hook  = "[DeathScreen] Hook framework : src %d est mort (%s)",
    log_external_revive = "[DeathScreen] Revie externe : src %d envoyé à %s",
    log_medic_revive    = "[DeathScreen] Réanimation médecin : src %d a réanimé src %d",
    log_avatar_fail     = "[DeathScreen] Échec analyse avatar Discord pour src %d",
    log_avatar_http     = "[DeathScreen] Discord API échouée (HTTP %s) pour src %d",

    embed_victim        = "Victime",
    embed_killer        = "Tueur",
    embed_weapon        = "Arme",
    embed_location      = "Lieu",
    embed_time          = "Heure",
    embed_distance      = "Distance",
    embed_died_title    = "%s est mort.",
    embed_respawn_title = "%s est réapparu.",
    embed_player        = "Joueur",
    embed_spawn_loc     = "Lieu",

    unknown             = "Inconnu",
    the_world           = "Le Monde",
    fall_damage         = "Chute",
    unknown_npc         = "PNJ",
    death_site          = "Lieu du décès",

    nearby_help_alert   = "[!] %s a besoin d'aide près de %s !",

    ui = {
        you_are          = "VOUS ÊTES",
        dead             = "Mort !",
        info_btn         = "[J] Infos",
        killed_by_prefix = "Vous avez été tué par",
        killed_by_mid    = "avec une",
        killed_by_suffix = "arme",
        time_label       = "Heure",
        distance_label   = "Distance",
    },
}

Locales['it'] = {
    revived             = "Sei stato rianimato.",
    help_sent           = "Aiuto inviato! (%d giocatori vicini avvisati)",
    help_failed         = "Impossibile inviare la richiesta di aiuto.",

    version_new         = "[%s] Nuova versione disponibile!",
    version_current     = "Versione attuale: ",
    version_latest      = "Ultima versione:  ",
    version_changelog   = "Changelog:",
    version_up_to_date  = "[cDeathScreen] Stai usando l'ultima versione! (%s)",
    version_parse_fail  = "[cDeathScreen] Impossibile analizzare i dati della versione!",
    version_http_fail   = "[cDeathScreen] Controllo versione fallito! (HTTP %s)",

    log_died            = "%s ucciso da %s (%s) a %s",
    log_respawned       = "%s rinato a %s (%.1f, %.1f)",
    log_call_help       = "%s ha chiamato aiuto — %d giocatori avvisati",
    log_session_miss    = "[DeathScreen] Richiesta respawn da src %d senza sessione attiva",
    log_framework_hook  = "[DeathScreen] Hook framework: src %d morto (%s)",
    log_external_revive = "[DeathScreen] Rivita esterna: src %d inviato a %s",
    log_medic_revive    = "[DeathScreen] Rianimazione medico: src %d ha rianimato src %d",
    log_avatar_fail     = "[DeathScreen] Analisi avatar Discord fallita per src %d",
    log_avatar_http     = "[DeathScreen] Discord API fallita (HTTP %s) per src %d",

    embed_victim        = "Vittima",
    embed_killer        = "Assassino",
    embed_weapon        = "Arma",
    embed_location      = "Posizione",
    embed_time          = "Ora",
    embed_distance      = "Distanza",
    embed_died_title    = "%s è morto.",
    embed_respawn_title = "%s è rinato.",
    embed_player        = "Giocatore",
    embed_spawn_loc     = "Posizione",

    unknown             = "Sconosciuto",
    the_world           = "Il Mondo",
    fall_damage         = "Danno da caduta",
    unknown_npc         = "NPC",
    death_site          = "Luogo del decesso",

    nearby_help_alert   = "[!] %s ha bisogno di aiuto vicino a %s!",

    ui = {
        you_are          = "SEI",
        dead             = "Morto!",
        info_btn         = "[J] Info",
        killed_by_prefix = "Sei stato ucciso da",
        killed_by_mid    = "con un'arma",
        killed_by_suffix = "",
        time_label       = "Ora",
        distance_label   = "Distanza",
    },
}

Locales['es'] = {
    revived             = "Has sido revivido.",
    help_sent           = "¡Ayuda enviada! (%d jugadores cercanos notificados)",
    help_failed         = "No se pudo enviar la llamada de ayuda.",

    version_new         = "[%s] ¡Nueva versión disponible!",
    version_current     = "Versión actual: ",
    version_latest      = "Última versión: ",
    version_changelog   = "Registro de cambios:",
    version_up_to_date  = "[cDeathScreen] ¡Estás usando la última versión! (%s)",
    version_parse_fail  = "[cDeathScreen] ¡Error al analizar los datos de versión!",
    version_http_fail   = "[cDeathScreen] ¡Comprobación de versión fallida! (HTTP %s)",

    log_died            = "%s asesinado por %s (%s) en %s",
    log_respawned       = "%s renació en %s (%.1f, %.1f)",
    log_call_help       = "%s pidió ayuda — %d jugadores notificados",
    log_session_miss    = "[DeathScreen] Solicitud de reaparición de src %d sin sesión activa",
    log_framework_hook  = "[DeathScreen] Hook de framework: src %d murió (%s)",
    log_external_revive = "[DeathScreen] Revivir externo: src %d enviado a %s",
    log_medic_revive    = "[DeathScreen] Revivir médico: src %d revivió a src %d",
    log_avatar_fail     = "[DeathScreen] Error al analizar avatar de Discord para src %d",
    log_avatar_http     = "[DeathScreen] Discord API falló (HTTP %s) para src %d",

    embed_victim        = "Víctima",
    embed_killer        = "Asesino",
    embed_weapon        = "Arma",
    embed_location      = "Ubicación",
    embed_time          = "Hora",
    embed_distance      = "Distancia",
    embed_died_title    = "%s ha muerto.",
    embed_respawn_title = "%s ha reaparecido.",
    embed_player        = "Jugador",
    embed_spawn_loc     = "Ubicación",

    unknown             = "Desconocido",
    the_world           = "El Mundo",
    fall_damage         = "Daño por caída",
    unknown_npc         = "NPC",
    death_site          = "Lugar de muerte",

    nearby_help_alert   = "[!] ¡%s necesita ayuda cerca de %s!",

    ui = {
        you_are          = "ESTÁS",
        dead             = "¡Muerto!",
        info_btn         = "[J] Info",
        killed_by_prefix = "Fuiste asesinado por",
        killed_by_mid    = "con un",
        killed_by_suffix = "arma",
        time_label       = "Hora",
        distance_label   = "Distancia",
    },
}

function T(key, ...)
    local lang   = exports["cBase"]:GetLangPreference() or "en"
    local locale = Locales[lang] or Locales["en"]
    local str    = locale[key] or (Locales["en"] and Locales["en"][key]) or key
    if select("#", ...) > 0 then
        return string.format(str, ...)
    end
    return str
end

function TUI()
    local lang   = exports["cBase"]:GetLangPreference() or "en"
    local locale = Locales[lang] or Locales["en"]
    local base   = Locales["en"].ui
    local over   = (locale.ui) or {}
    local result = {}
    for k, v in pairs(base) do
        result[k] = over[k] or v
    end
    return result
end