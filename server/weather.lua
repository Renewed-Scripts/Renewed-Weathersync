local buildWeatherList = require 'server.weatherbuilder'

local useScheduledWeather = require 'config.weather'.useScheduledWeather
local weatherList = buildWeatherList()

local overrideWeather = false

-- weatherList executor --
local function executeCurrentWeather()
    local weather = weatherList[1]

    if weather then
        GlobalState.weather = weather
    end

    return weather
end

local function runWeatherList()
    table.sort(weatherList, function (a, b)
        return a.epochTime < b.epochTime
    end)

    local currentWeather = executeCurrentWeather()

    while not overrideWeather do

        if weatherList[1] then
            currentWeather.time -= 1

            if currentWeather.time <= 0 then
                table.remove(weatherList, 1)
                currentWeather = executeCurrentWeather()
            end
        else
            currentWeather = executeCurrentWeather()
        end
        Wait(60000)
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

        if index == 1 then
            local currentWeather = weatherList[1]
            currentWeather.weather = weatherType

            GlobalState.weather = currentWeather
        end

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

        return eventTime
    end

    return false
end)

lib.addCommand('weather', {
    help = 'View and set the current weather forecast',
    restricted = 'group.admin',
}, function(source)
    TriggerClientEvent('Renewed-Weather:client:viewWeatherInfo', source, weatherList)
end)


-- Scheduled restart --
if useScheduledWeather then
    AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
        local secondsRemaining = eventData.secondsRemaining
        local weather = secondsRemaining == 900 and 'OVERCAST' or secondsRemaining == 600 and 'RAIN' or secondsRemaining == 300 and 'THUNDER'

        if weather then
            overrideWeather = true
            GlobalState.weather = {
                weather = weather,
                time = 9000000
            }
        end
    end)
end