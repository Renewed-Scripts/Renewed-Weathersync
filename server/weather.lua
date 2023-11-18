local buildWeatherList = require 'server.weatherbuilder'

local weatherList = buildWeatherList()


-- weatherList executor --
local function runWeatherList()
    table.sort(weatherList, function (a, b)
        return a.epochTime < b.epochTime
    end)

    for i = 1, #weatherList do
        local currentWeather = weatherList[i]

        if currentWeather then
            GlobalState.weather = currentWeather
            Wait(currentWeather.time * 60000)
        end
    end
end

CreateThread(runWeatherList)

-- Admin related events --
RegisterNetEvent('Renewed-Weather:server:removeWeatherEvent', function(index)
    if IsPlayerAceAllowed(source, 'command.weather') and weatherList[index] then
        table.remove(weatherList, index)
    end
end)

lib.callback.register('Renewed-Weathersync:server:setWeatherType', function(source, index, weatherType)
    if IsPlayerAceAllowed(source, 'command.weather') and weatherList[index] then
        weatherList[index].weather = weatherType

        return weatherType
    end

    return false
end)

lib.callback.register('Renewed-Weathersync:server:setEventTime', function(source, index, eventTime)
    local weatherEvent = weatherList[index]

    if IsPlayerAceAllowed(source, 'command.weather') and weatherEvent then
        local isMinus = eventTime < weatherEvent.time
        local eventTimeEpoch = eventTime * 60

        weatherEvent.time = eventTime

        -- Itterate through the queue behind the edited event and adjust the epoch timecycle
        for i = index + 1, #weatherList do
            local currentWeather = weatherList[i]
            if isMinus then
                currentWeather.epochTime -= eventTimeEpoch
            else
                currentWeather.epochTime += eventTimeEpoch
            end
        end

        return weatherType
    end

    return false
end)

lib.addCommand('weather', {
    help = 'View and set the current weather forecast',
    restricted = 'group.admin',
}, function(source)
    TriggerClientEvent('Renewed-Weather:client:viewWeatherInfo', source, weatherList)
end)