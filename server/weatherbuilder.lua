local Config = lib.load('config.weather')

-- Holy shit I had cancer when I wrote this dogshit not even gonna try and save this spaghetti mess rn

local weather_class = require 'classes.weather'

local currentMonth = tonumber(os.date('%m'))

local cycleTimer = Config.weatherCycletimer

local rainFilter = {
    ['RAIN'] = true,
    ['THUNDER'] = true,
}

local math_random = math.random

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
    return sequence.probability >= math_random() and (not sequence.month or sequence.month == currentMonth) and (not hasRain or (timeBeforeRain <= 0 and minutesSinceRain >= Config.timeBetweenRain))
end

local function insertEvents(events, weatherList)
    local timeUsed = 0
    for j = 1, #events do
        ---@diagnostic disable-next-line: invisible
        local weather = weather_class:new(events[j])

        weatherList[#weatherList+1] = weather
        timeUsed += weather.time
    end

    return timeUsed
end

local function insertAllowedSequences(sequences, minutesSinceRain, timeBeforeRain)
    local timeUsed = 0

    local weatherList = {}

    for i = 1, #sequences do
        local sequence = sequences[i]

        local hasRain = containsRain(sequence.events)
        if isSequenceAllowed(sequence, hasRain, minutesSinceRain, timeBeforeRain) then
            local sequenceTime = insertEvents(sequence.events, weatherList)
            timeUsed += sequenceTime
            minutesSinceRain = hasRain and 0 or minutesSinceRain + timeUsed
            timeBeforeRain = not hasRain and timeBeforeRain - timeUsed or timeBeforeRain
        end
    end

    return timeUsed, minutesSinceRain, weatherList
end


-- Weather Event Functions --
local function isWeatherEventAllowed(chance, hasRain, minutesSinceRain, timeBeforeRain, weather, weatherList, weatherAmount)
    local isAllowed = chance >= math_random() and (not hasRain or (timeBeforeRain <= 0 and minutesSinceRain >= Config.timeBetweenRain))

    if isAllowed and weatherAmount > 5 then
        local count = 0
        for i = weatherAmount - 5, weatherAmount do
            if weatherList[i].weather == weather then
                count += 1
                
                if count > 1 then
                    return false
                end
            end
        end
    end


    return isAllowed
end

local function getWeatherEvent(weather)
    return {
        weather = weather,
        time = cycleTimer
    }
end

local function getDecemberSnow()
    return {
        ---@diagnostic disable-next-line: invisible
        weather_class:new({
            weather = 'XMAS',
            time = 86400,
            windSpeed = 0.0,
            windDirection = 0.0,
        })
    }
end

local function concatArray(t1, t2)
    local length = #t2
    if length > 0 then
        for i = 1, length do
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
    local timeBeforeRain = Config.rainAfterRestart

    while true do
        if Config.useWeatherSequences then
            local timeUsed, rainMinutes, sequenceList = insertAllowedSequences(Config.weatherSequences, minutesSinceRain, timeBeforeRain)
            minutesSinceRain = rainMinutes
            minutesLeft -= timeUsed
            timeBeforeRain = rainMinutes == 0 and timeBeforeRain - timeUsed or timeBeforeRain
            concatArray(weatherList, sequenceList)
        end

        if Config.useStaticWeather then
            local weatherCount = #weatherList

            for weather, chance in pairs(Config.staticWeather) do
                local hasRain = rainFilter[weather]
                if isWeatherEventAllowed(chance, hasRain, minutesSinceRain, timeBeforeRain, weather, weatherList, weatherCount) then
                    weatherCount += 1
                    ---@diagnostic disable-next-line: invisible
                    weatherList[weatherCount] = weather_class:new(getWeatherEvent(weather))
                    minutesSinceRain = hasRain and 0 or minutesSinceRain + cycleTimer
                    timeBeforeRain = not hasRain and timeBeforeRain - cycleTimer or timeBeforeRain
                    minutesLeft -= cycleTimer
                end
            end
        end

        if minutesLeft <= 0 then
            return weatherList
        end

        Wait(0)
    end
end
