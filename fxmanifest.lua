fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'CodeRanch - Ked.ss'
description 'CodeRanch Death Screen'
version '1.0.0'

lua54 'yes'

shared_scripts {'@cBase/shared/rpc.lua', 'shared/config.lua', 'locales/locale.lua'}

client_scripts {'@cBase/client/functions.lua', '@cBase/client/main.lua', 'client/main.lua'}

server_scripts {'@oxmysql/lib/MySQL.lua', '@cBase/server/functions.lua', '@cBase/server/main.lua', 'server/main.lua',
                'shared/sv_config.lua'}

ui_page 'html/index.html'

files {'html/index.html', 'html/assets/**.**'}

escrow_ignored {'shared/**.lua', 'locales/**.lua'}
