local Config = require 'config.time'


-- GlobalState checks here are to ensure that the if the script is being restarted live the time doesn't reset.
local nightScale = Config.timeScaleNight
local nightStart, nightEnd = Config.nightTime.beginning, Config.nightTime.ending
local configScale = Config.timeScale
local currentScale = GlobalState.timeScale or (configScale > 2000 and configScale) or 2000
local freezeTime = GlobalState.freezeTime or false
local startTime = GlobalState.currentTime or {
    hour = Config.startUpHour,
    minute = Config.startUpMinute,
}

local minute = startTime.minute
local hour = startTime.hour

-- Syncs the GlobalStates (does not replicate if the values are the same)
GlobalState.timeScale = currentScale
GlobalState.freezeTime = freezeTime


-- Loop that syncs the minute and hours of the servers to clients.
CreateThread(function()
    while true do
        if not freezeTime then
            GlobalState.currentTime = {
                minute = minute == 59 and 0 or minute + 1,
                hour = minute == 59 and (hour == 23 and 0 or hour + 1) or hour,
            }
        end

        Wait(currentScale)
    end
end)


--[[
    Add server side statebag change handlers so third party resources can set globalstates and we can replicate the data.
]]
AddStateBagChangeHandler('freezeTime', nil, function(bagName, _, value)
    if bagName == 'global' and value and next(value) then
        freezeTime = value
    end
end)

AddStateBagChangeHandler('currentTime', nil, function(bagName, _, value)
    if bagName == 'global' and value then
        hour = value.hour
        minute = value.minute

        if (hour > nightStart or hour < nightEnd) and currentScale ~= nightScale then
            currentScale = nightScale
            GlobalState.timeScale = currentScale
        elseif (hour < nightStart and hour > nightEnd) and currentScale ~= configScale then
            currentScale = configScale
            GlobalState.timeScale = currentScale
        end
    end
end)

AddStateBagChangeHandler('timeScale', nil, function(bagName, _, value)
    if bagName == 'global' and value then
        currentScale = value
    end
end)

lib.addCommand('time', {
    help = 'Set the current time',
    restricted = 'group.admin',
    params = {
        {
            name = 'hour',
            type = 'number',
            help = 'set the Hour',
        },
        {
            name = 'minute',
            type = 'number',
            help = 'set the Minute',
            optional = true
        },
    },
}, function(_, args) -- source, args
    local newHours, newMinutes = args.hour, args.minute or 0

    GlobalState.currentTime = {
        hour = newHours > 23 and 0 or newHours < 0 and 0 or newHours,
        minute = newMinutes > 59 and 59 or newMinutes < 0 and 0 or newMinutes,
    }
end)

lib.addCommand('timescale', {
    help = ('Set milliseconds per game second (default %s)'):format(currentScale),
    restricted = 'group.admin',
    params = {
        {
            name = 'scale',
            type = 'number',
            help = 'Milliseconds per game second',
        },
    },
}, function(_, args) -- source, args
    if args.scale > 2000 then
        GlobalState.timeScale = args.scale
    end
end)

lib.addCommand('freezetime', {
    help = 'Freeze / unfreeze time',
    restricted = 'group.admin',
    params = {
        {
            name = 'time',
            type = 'number',
            help = 'Freeze time? (1 = yes, 0 = no)',
        },
    },
}, function(_, args)
    local newFreeze = args.time == 1 and true or false

    GlobalState.freezeTime = newFreeze
end)