fx_version "cerulean"
lua54 'yes'
game "gta5"

ui_page 'web/dist/index.html'

shared_script '@Index/imports/main.lua'
shared_script 'config.lua'

client_script {
  'resources/belt/client.lua',
  'resources/vehicle/client.lua',

  'resources/health/client.lua',
  'resources/stamina/client.lua',
  'resources/basic/client.lua',
  'resources/oxygen/client.lua',
  'resources/death/client.lua',
  "client.lua"
}

files {
  'web/dist/index.html',
  'web/dist/**/*',

  'modules/**/*.lua',
  'modules/**/*.json'
}
