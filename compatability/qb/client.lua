if GetResourceState('qb-core') == 'missing' and GetResourceState('qbx_core') == 'missing' then return end
local playerState = LocalPlayer.state

RegisterNetEvent('qb-weathersync:client:DisableSync', function()
    playerState.syncWeather = false
end)

RegisterNetEvent('qb-weathersync:client:EnableSync', function()
    playerState.syncWeather = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerState.syncWeather = true
end)