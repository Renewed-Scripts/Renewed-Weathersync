local Config = require 'config.weather'

local currentMonth = tonumber(os.date('%m'))

local cycleTimer = Config.weatherCycletimer

local rainFilter = {
    ['RAIN'] = true,
    ['THUNDER'] = true,
}

-- Sequence Functions --
local function containsRain(sequence)
    for i = 1, #sequence do
        if rainFilter[sequence[i].weather] then
            return true
        end
    end

    return false
end

local function isSequenceAllowed(sequence, hasRain, minutesSinceRain, timeBeforeRain)
    return sequence.probability >= math.random() and (not sequence.month or sequence.month == currentMonth) and (not hasRain or minutesSinceRain >= Config.timeBetweenRain or timeBeforeRain <= 0)
end

local function insertEvents(events, weatherList, weatherInEpoch)
    local timeUsed = 0
    for j = 1, #events do
        local weather = events[j]

        weather.epochTime = weatherInEpoch
        weatherList[#weatherList+1] = weather
        timeUsed += weather.time
        weatherInEpoch += weather.time * 60
    end

    return timeUsed
end

local function insertAllowedSequences(sequences, minutesSinceRain, weatherInEpoch, timeBeforeRain)
    local timeUsed = 0

    local weatherList = {}

    for i = 1, #sequences do
        local sequence = sequences[i]

        local hasRain = containsRain(sequence.events)
        if isSequenceAllowed(sequence, hasRain, minutesSinceRain, timeBeforeRain) then
            local sequenceTime = insertEvents(sequence.events, weatherList, weatherInEpoch)
            timeUsed += sequenceTime
            weatherInEpoch += sequenceTime * 60
            minutesSinceRain = hasRain and 0 or minutesSinceRain + timeUsed
            timeBeforeRain = not hasRain and timeBeforeRain - timeUsed or timeBeforeRain
        end
    end

    return timeUsed, minutesSinceRain, weatherList
end


-- Weather Event Functions --
local function isWeatherEventAllowed(chance, hasRain, minutesSinceRain, timeBeforeRain)
    return chance >= math.random() and (not hasRain or minutesSinceRain >= Config.timeBetweenRain or timeBeforeRain <= 0)
end

local function getWeatherEvent(weather, weatherInEpoch)
    return {
        weather = weather,
        time = cycleTimer,
        epochTime = weatherInEpoch,
    }
end

local function getDecemberSnow()
    return {
        {
            weather = 'XMAS',
            time = 86400,
            windSpeed = 0.0,
            windDirection = 0.0,
        }
    }
end

local function concatArray(t1, t2)
    if #t2 > 0 then
        for i = 1, #t2 do
            t1[#t1+1] = t2[i]
        end
    end
end

return function()
    local weatherList = {}

    if Config.decemberSnow and currentMonth == 12 then
        return getDecemberSnow()
    end

    local minutesLeft = Config.serverDuration * 60
    local minutesSinceRain = Config.timeBetweenRain + 1
    local weatherInEpoch = os.time()

    local timeBeforeRain = Config.rainAfterRestart

    while true do
        if Config.useWeatherSequences then
            local timeUsed, rainMinutes, sequenceList = insertAllowedSequences(Config.weatherSequences, minutesSinceRain, weatherInEpoch, timeBeforeRain)
            minutesSinceRain = rainMinutes
            minutesLeft -= timeUsed
            weatherInEpoch += timeUsed * 60
            timeBeforeRain = rainMinutes == 0 and timeBeforeRain - timeUsed or timeBeforeRain
            concatArray(weatherList, sequenceList)
        end

        if Config.useStaticWeather then
            for weather, chance in pairs(Config.staticWeather) do
                local hasRain = rainFilter[weather]
                if isWeatherEventAllowed(chance, hasRain, minutesSinceRain, timeBeforeRain) then
                    weatherList[#weatherList+1] = getWeatherEvent(weather, weatherInEpoch)
                    minutesSinceRain = hasRain and 0 or minutesSinceRain + cycleTimer
                    timeBeforeRain = not hasRain and timeBeforeRain - cycleTimer or timeBeforeRain
                    minutesLeft -= cycleTimer
                    weatherInEpoch += cycleTimer * 60
                end
            end
        end

        if minutesLeft <= 0 then
            return weatherList
        end

        Wait(0)
    end
end
