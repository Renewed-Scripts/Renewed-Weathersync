local serverWeather = GlobalState.weather
local hadSnow = false
local playerState = LocalPlayer.state

local function resetWeatherParticles()
    if hadSnow then
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
        ForceSnowPass(false)
        WaterOverrideSetStrength(0.5)
        RemoveNamedPtfxAsset('core_snow')
        hadSnow = false
    end
end

local function setWeatherParticles()
    if not hadSnow then
        lib.requestNamedPtfxAsset('core_snow', 1000)
        UseParticleFxAsset('core_snow')

        ForceSnowPass(true)
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
        WaterOverrideSetStrength(0.9)

        hadSnow = true
    end
end

local function setWeather(forceSwap)
    SetRainLevel(-1.0)

    if forceSwap then
        SetWeatherTypeNowPersist(serverWeather.weather)
    else
        SetWeatherTypeOvertimePersist(serverWeather.weather, 60.0)
    end

    if serverWeather.windDirection then
        SetWindDirection(math.rad(serverWeather.WindDirection))
    end

    if serverWeather.windSpeed then
        SetWind(serverWeather.windSpeed / 2)
    end

    if serverWeather.hasSnow then
        setWeatherParticles()
    end

    if not serverWeather.hasSnow and hadSnow then
        resetWeatherParticles()
    end
end

AddStateBagChangeHandler('weather', nil, function(bagName, _, value)
    if value and bagName == 'global' then
        serverWeather = value

        if playerState.syncWeather then
            setWeather()
        end
    end
end)

AddStateBagChangeHandler('blackOut', nil, function(bagName, _, value)
    if value and bagName == 'global' then
        SetArtificialLightsState(value)
        SetArtificialLightsStateAffectsVehicles(false)
    end
end)

-- Some startup shit --
CreateThread(function ()
    SetWind(0.1)
    WaterOverrideSetStrength(0.5)

    setWeather(true)

    playerState.syncWeather = true
end)

AddStateBagChangeHandler('syncWeather', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value then
        SetTimeout(0, function()
            while not playerState.syncWeather do
                SetRainLevel(0.0)
                SetWeatherTypePersist('CLEAR')
                SetWeatherTypeNow('CLEAR')
                SetWeatherTypeNowPersist('CLEAR')
                NetworkOverrideClockTime(18, 0, 0)
                Wait(5000)
            end
        end)
    else
        setWeather(true)
    end
end)