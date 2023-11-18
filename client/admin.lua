-- Weather Admin Management --
local weatherTypes = {
    {
        label = 'Blizzard',
        value = 'BLIZZARD'
    },
    {
        label = 'Clear',
        value = 'CLEAR'
    },
    {
        label = 'Clearing',
        value = 'CLEARING'
    },
    {
        label = 'Clouds',
        value = 'CLOUDS'
    },
    {
        label = 'Extra Sunny',
        value = 'EXTRASUNNY'
    },
    {
        label = 'Foggy',
        value = 'FOGGY'
    },
    {
        label = 'Neutral',
        value = 'NEUTRAL'
    },
    {
        label = 'Overcast',
        value = 'OVERCAST'
    },
    {
        label = 'Rain',
        value = 'RAIN'
    },
    {
        label = 'Smog',
        value = 'SMOG'
    },
    {
        label = 'Snow',
        value = 'SNOW'
    },
    {
        label = 'Snowlight',
        value = 'SNOWLIGHT'
    },
    {
        label = 'Thunder',
        value = 'THUNDER'
    },
    {
        label = 'Xmas',
        value = 'XMAS'
    },
}

local function viewWeatherEvent(index, weatherEvent)
    lib.registerContext({
        id = 'Renewed-Weathersync:client:changeWeather',
        title = 'Change Weather',
        menu = 'Renewed-Weathersync:client:manageWeather',
        options = {
            {
                title = 'Info',
                icon = 'fa-solid fa-circle-info',
                readOnly = true,
                metadata = {
                    ('Weather %s'):format(weatherEvent.weather),
                    ('Starting in %s minutes'):format(math.floor((weatherEvent.epochTime - GetCloudTimeAsInt()) / 60)),
                    ('Lasting for %s minutes'):format(weatherEvent.time)
                }
            },
            {
                title = 'Change Weather',
                icon = 'fa-solid fa-cloud',
                arrow = true,
                onSelect = function()
                    local input = lib.inputDialog('Change Weather Type', {
                        {
                            label = 'Select Weather',
                            type = 'select',
                            required = true,
                            default = weatherEvent.weather,
                            options = weatherTypes
                        },
                    })

                    if input and input[1] then
                        local weather = lib.callback.await('Renewed-Weathersync:server:setWeatherType', false, index, input[1])

                        if weather then
                            weatherEvent.weather = weather
                        end
                    end

                    viewWeatherEvent(index, weatherEvent)
                end
            },
            {
                title = 'Change Duration',
                arrow = true,
                icon = 'fa-solid fa-hourglass-half',
                onSelect = function()
                    local input = lib.inputDialog('Change Duration', {
                        {
                            label = 'Duration in minutes',
                            type = 'slider',
                            required = true,
                            min = 1,
                            max = 120,
                            default = weatherEvent.time,
                        },
                    })

                    if input and input[1] then
                        local time = lib.callback.await('Renewed-Weathersync:server:setEventTime', false, index, input[1])

                        if time then
                            weatherEvent.time = time
                        end
                    end

                    viewWeatherEvent(index, weatherEvent)
                end
            },
            {
                title = 'Remove Weather Event',
                arrow = true,
                icon = 'fa-solid fa-circle-xmark',
                onSelect = function()
                    TriggerServerEvent('Renewed-Weather:server:removeWeatherEvent', index)
                end
            }
        }
    })

    lib.showContext('Renewed-Weathersync:client:changeWeather')
end

RegisterNetEvent('Renewed-Weather:client:viewWeatherInfo', function(weatherTable)
    local options = {}
    local amt = 0

    local currentTime = GetCloudTimeAsInt()

    for i = 1, #weatherTable do
        local currentWeather = weatherTable[i]
        amt += 1

        local isQueued = i > 1

        local epochMinute = math.floor((currentWeather.epochTime - currentTime ) / 60)

        options[amt] = {
            title = isQueued and currentWeather.weather or ('Current Weather: %s'):format(currentWeather.weather),
            description = isQueued and ('Starting in %s minutes'):format(epochMinute),
            arrow = isQueued,
            readOnly = not isQueued,
            icon = isQueued and 'fa-solid fa-cloud-arrow-up' or 'fa-solid fa-cloud',
            metadata = isQueued and {
                ('Weather %s'):format(currentWeather.weather),
                ('Starting in %s minutes'):format(epochMinute),
                ('Lasting for %s minutes'):format(currentWeather.time)
            },
            onSelect = isQueued and function()
                viewWeatherEvent(i, currentWeather)
            end
        }
    end


    lib.registerContext({
        id = 'Renewed-Weathersync:client:manageWeather',
        title = 'Weather Management',
        options = options
    })

    lib.showContext('Renewed-Weathersync:client:manageWeather')
end)