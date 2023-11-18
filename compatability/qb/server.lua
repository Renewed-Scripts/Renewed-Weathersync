local Config = require 'config.weather'

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
    GlobalState.weather.weather = weather
end)

exportHandler('setTime', function(hour, minute)
    GlobalState.currentTime = {
        hour = hour,
        minute = minute,
    }
end)

exportHandler('setBlackout', function(state)
    GlobalState.blackOut = state
end)

exportHandler('setTimeFreeze', function(state)
    GlobalState.freezeTime = state
end)

exportHandler('getBlackoutState', function()
    return GlobalState.blackOut
end)

exportHandler('getTimeFreezeState', function()
    return GlobalState.freezeTime
end)

exportHandler('getWeatherState', function()
    return GlobalState.weather?.weather
end)

exportHandler('getDynamicWeather', function()
    return Config.useWeatherSequences
end)

exportHandler('getTime', function()
    local currentTime = GlobalState.currentTime

    return currentTime.hour, currentTime.minute
end)