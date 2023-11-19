if GetResourceState('qb-core') == 'missing' and GetResourceState('qbx_core') == 'missing' then return end

local disablesync = false
local currentTime = GlobalState.currentTime
local currentWeather = GlobalState.weather

AddStateBagChangeHandler('currentTime', nil, function(bagName, _, value)
    if bagName == 'global' and value and next(value) then
        currentTime = value
    end
end)

AddStateBagChangeHandler('weather', nil, function(bagName, _, value)
    if value and bagName == 'global' then
        currentWeather = value
    end
end)

local function disabledSync()
    if not disablesync then
        disablesync = true
        NetworkOverrideClockMillisecondsPerGameMinute(99999999)
        CreateThread(function()
            while disablesync do
                SetRainLevel(0.0)
                SetWeatherTypePersist('CLEAR')
                SetWeatherTypeNow('CLEAR')
                SetWeatherTypeNowPersist('CLEAR')
                NetworkOverrideClockTime(18, 0, 0)
                Wait(5000)
            end
        end)
    end
end

local function enabledSync()
    if disablesync then
        NetworkOverrideClockTime(currentTime.hour, currentTime.minute, 0)

        if not GlobalState.freezeTime then
            NetworkOverrideClockMillisecondsPerGameMinute(GlobalState.timeScale)
        end

        SetWeatherTypePersist(currentWeather.weather)
        SetWeatherTypeNow(currentWeather.weather)
        SetWeatherTypeNowPersist(currentWeather.weather)

        disablesync = false
    end
end

RegisterNetEvent('qb-weathersync:client:DisableSync', disabledSync)
RegisterNetEvent('qb-weathersync:client:EnableSync', enabledSync)