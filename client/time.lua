local timeScale = GlobalState.timeScale

AddStateBagChangeHandler('currentTime', nil, function(bagName, _, value)
    if bagName == 'global' and value and next(value) then
        NetworkOverrideClockTime(value.hour, value.minute, 0)
    end
end)

AddStateBagChangeHandler('timeScale', nil, function(bagName, _, value)
    if bagName == 'global' and value then
        NetworkOverrideClockMillisecondsPerGameMinute(value)
        timeScale = value
    end
end)

AddStateBagChangeHandler('freezeTime', nil, function(bagName, _, value)
    if bagName == 'global' then
        NetworkOverrideClockMillisecondsPerGameMinute(value and 99999999 or timeScale)
    end
end)

NetworkOverrideClockMillisecondsPerGameMinute(timeScale)


require 'compatability.qb.client'