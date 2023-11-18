fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'Renewed Weather Sync'
author 'FjamZoo - Renewed Scripts'
version '0.69.420'

shared_scripts{
    '@ox_lib/init.lua',
}

client_script 'client/*.lua'

server_scripts {
    'server/time.lua',
    'server/weather.lua',
}

file 'compatability/**/client.lua'

provide 'qb-weathersync'