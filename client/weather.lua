local serverWeather = GlobalState.weather
local hadSnow = false

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

AddStateBagChangeHandler('weather', nil, function(bagName, _, value)
    if value and bagName == 'global' then
        SetRainLevel(-1.0)

        SetWeatherTypeOvertimePersist(value.weather, 60.0)

        if value.windDirection then
            SetWindDirection(math.rad(value.WindDirection))
        end

        if value.windSpeed then
            SetWind(value.windSpeed / 2)
        end

        if value.hasSnow then
            setWeatherParticles()
        end

        if not value.hasSnow and hadSnow then
            resetWeatherParticles()
        end

        serverWeather = value
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

    if serverWeather.windDirection then
        SetWindDirection(math.rad(serverWeather.windDirection))
    end

    if serverWeather.windSpeed then
        SetWind(serverWeather.windSpeed / 2)
    end

    if serverWeather.hasSnow then
        setWeatherParticles()
    end

    SetRainLevel(-1.0)
    SetWeatherTypeNowPersist(serverWeather.weather)
end)