if GetConvar('weather_disablecd', 'false') == 'true' then
    return
end

local cd_weather = {}

AddStateBagChangeHandler('weather', 'global', function(_, _, value)
    if value then
        cd_weather.weather = value.weather
    end
end)

AddStateBagChangeHandler('blackOut', 'global', function(_, _, value)
    cd_weather.blackout = value
end)

AddStateBagChangeHandler('freezeTime', 'global', function(_, _, value)
    cd_weather.freeze = value
end)

AddEventHandler('__cfx_export_cd_easytime_GetWeather', function()
    return cd_weather
end)