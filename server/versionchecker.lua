local resourceName   = GetCurrentResourceName()
local currentVersion = GetResourceMetadata(resourceName, "version", 0)

Citizen.CreateThread(function()
    local link = "https://raw.githubusercontent.com/CodeRanchRed/versions/main/version.json?v=" .. os.time()

    PerformHttpRequest(link, function(err, text, headers)
        if err == 200 then
            local success, versionData = pcall(function()
                return json.decode(text)
            end)

            if success and versionData and versionData["cDeathScreen"] then
                local data          = versionData["cDeathScreen"]
                local latestVersion = data.version
                local changelog     = data.changelog or {}

                if currentVersion ~= latestVersion then
                    print("^0")
                    print("^3========================================^0")
                    print(("^3%s^0"):format(T("version_new", resourceName)))
                    print(("^7%s^1%s^0"):format(T("version_current"), currentVersion))
                    print(("^7%s^2%s^0"):format(T("version_latest"),  latestVersion))
                    print("^0")
                    print(("^7%s^0"):format(T("version_changelog")))
                    for _, change in ipairs(changelog) do
                        print(("^7  • %s^0"):format(change))
                    end
                    print("^3========================================^0")
                    print("^0")
                else
                    print(("^2%s^0"):format(T("version_up_to_date", currentVersion)))
                end
            else
                print(("^1%s^0"):format(T("version_parse_fail")))
            end
        else
            print(("^1%s^0"):format(T("version_http_fail", tostring(err))))
        end
    end, "GET", "")
end)