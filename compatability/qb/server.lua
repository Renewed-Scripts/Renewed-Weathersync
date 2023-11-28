local Config = require 'config.weather'

local globalState = GlobalState

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-weathersync_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('nextWeatherStage', function()
    return print("RENEWED WEATHERSYNC - THIS EXPORT IS NOT SUPPORTED")
end)

exportHandler('setDynamicWeather', function()
    return print("RENEWED WEATHERSYNC - THIS EXPORT IS NOT SUPPORTED")
end)


exportHandler('setWeather', function(weather)
    globalState.weather = {
        weather = weather,
        time = 9999999999
    }
end)

exportHandler('setTime', function(hour, minute)
    globalState.currentTime = {
        hour = hour,
        minute = minute,
    }
end)

exportHandler('setBlackout', function(state)
    globalState.blackOut = state
end)

exportHandler('setTimeFreeze', function(state)
    globalState.freezeTime = state
end)

exportHandler('getBlackoutState', function()
    return globalState.blackOut
end)

exportHandler('getTimeFreezeState', function()
    return globalState.freezeTime
end)

exportHandler('getWeatherState', function()
    return globalState.weather?.weather
end)

exportHandler('getDynamicWeather', function()
    return Config.useWeatherSequences
end)

exportHandler('getTime', function()
    local currentTime = globalState.currentTime

    return currentTime.hour, currentTime.minute
end)

RegisterNetEvent('qb-weathersync:server:setWeather', function(weather)
    if not IsPlayerAceAllowed(source, 'command.weather') then
        return
    end
    globalState.weather = {
        weather = weather,
        time = 9999999999
    }
end)

RegisterNetEvent('qb-weathersync:server:setTime', function(hour, minute)
    if not IsPlayerAceAllowed(source, 'command.time') then
        return
    end
    globalState.currentTime = {
        hour = tonumber(hour),
        minute = tonumber(minute) or 0,
     }
end)
