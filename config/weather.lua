return {

    serverDuration = 14, -- How many hours will the server run before restarting?, if a server restarts every 8 hours put this to 9 etc.
    weatherCycletimer = 30, -- How many minutes between weather changes
    timeBetweenRain = 180, -- How many minutes between rain events

    decemberSnow = true, -- if turned on means that snow will only happen in december

    useStaticWeather = true,
    staticWeather = {
        ['BLIZZARD'] = 0.0, --0% chance
        ['CLEAR'] = 0.1, -- 10% chance
        ['CLEARING'] = 0.1, -- 10% chance
        ['CLOUDS'] = 0.1, -- 10% chance
        ['EXTRASUNNY'] = 0.4, -- 40% chance
        ['FOGGY'] = 0.1,
        ['NEUTRAL'] = 0.1,
        ['OVERCAST'] = 0.1,
        ['RAIN'] = 0.1,
        ['SMOG'] = 0.1,
        ['SNOW'] = 0.0,
        ['SNOWLIGHT'] = 0.0,
        ['THUNDER'] = 0.1,
        ['XMAS'] = 0.0
    },

    useWeatherSequences = true,

    weatherSequences = {

        { -- Sunny
            probability = 0.1, -- 10%
            events = {
                {
                    weather = 'SMOG',
                    time = math.random(3, 10), -- Minutes
                    windSpeed = 0.05,
                },
                {
                    weather = 'CLEAR',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(3, 10), -- Minutes
                    windSpeed = 0.05,
                }
            },
        },

        { -- cloudy
            probability = 0.10, -- 10%
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10),
                    windSpeed = 0.1,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 10),
                    windSpeed = 0.05,
                }
            },
        },

        { -- snowing
            probability = 0.3, -- 30%
            month = 12, -- What month can there be snow?
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.0,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'SNOW',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.3,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.0,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.0,
                },
            },
        },

        { -- snowstorm
            probability = 0.30, -- 30%
            windDirection = 120.0, -- Storms come from the south
            month = 12, -- What month can there be snow?
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'SNOW',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'SNOW',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 1.0,
                    HasSnow = true,
                },
                {
                    weather = 'BLIZZARD',
                    time = 14, -- Minutes
                    windSpeed = 3.0,
                    HasSnow = true,
                },
                {
                    weather = 'SNOW',
                    time = 15, -- Minutes
                    windSpeed = 2.0,
                    HasSnow = true,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = 20, -- Minutes
                    windSpeed = 1.0,
                    HasSnow = true,
                },
                {
                    weather = 'OVERCAST',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    HasSnow = true,
                },
                {
                    weather = 'CLOUDS',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    HasSnow = true,
                },
                {
                    weather = 'CLEAR',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    HasSnow = true,
                },
                {
                    weather = 'EXTRASUNNY',
                    windSpeed = 0.5,
                },
            },
        },

        { -- rainshower
            probability = 0.1, -- 10%
            windDirection = 240.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 2.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(5, 10),
                    windSpeed = 0.0,
                },
            },
        },

        { -- rainstorm
            probability = 0.10, -- 10%
            windDirection = 280.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 3.5,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.5,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7),
                    windSpeed = 0.5,
                },
            },
        },

        { -- smallstorm
            probability = 0.10, -- 10%
            windDirection = 120.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7),
                    windSpeed = 0.5,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 1.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 3.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 2.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7),
                    windSpeed = 1.0,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(5, 10),
                    windSpeed = 0.5,
                },
            },
        },

        { -- bigstorm
            windDirection = 180.0, -- Storms come from the south
            probability = 0.10, -- 10%
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7),
                    windSpeed = 4.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 8.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7),
                    windSpeed = 3.0,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(3, 7),
                    windSpeed = 0.0,
                },
            },
        },
    }
}





