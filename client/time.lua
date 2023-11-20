local timeScale = GlobalState.timeScale
local currentTime = GlobalState.currentTime
local timeFrozen = GlobalState.freezeTime
local playerState = LocalPlayer.state

AddStateBagChangeHandler('currentTime', 'global', function(_, _, value)
    if value and next(value) then

        if playerState.syncWeather then
            NetworkOverrideClockTime(value.hour, value.minute, 0)
        end

        currentTime = value
    end
end)

AddStateBagChangeHandler('timeScale', 'global', function(_, _, value)
    if value then

        if playerState.syncWeather then
            NetworkOverrideClockMillisecondsPerGameMinute(value)
        end

        timeScale = value
    end
end)

AddStateBagChangeHandler('freezeTime', 'global', function(_, _, value)
    if playerState.syncWeather then
        NetworkOverrideClockMillisecondsPerGameMinute(value and 99999999 or timeScale)
    end

    timeFrozen = value
end)

NetworkOverrideClockMillisecondsPerGameMinute(timeScale)

AddStateBagChangeHandler('syncWeather', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value then
        NetworkOverrideClockTime(currentTime.hour, currentTime.minute, 0)
        if not timeFrozen then
            NetworkOverrideClockMillisecondsPerGameMinute(timeScale)
        end
    else
        NetworkOverrideClockMillisecondsPerGameMinute(99999999)
        NetworkOverrideClockTime(18, 0, 0)
    end
end)


require 'compatability.qb.client'