
---@class renewed_weather : OxClass
---@field weather string
---@field time number
---@field windSpeed? number
---@field windDirection? number
---@field isRain boolean
local weather_class = lib.class('renewed_weather')

---@class renewed_weather_payload
---@field weather string
---@field time number
---@field isRain boolean
---@field windSpeed? number
---@field windDirection? number

---@param payload {weather: string, time: number, windSpeed?: number, windDirection?: number}
function weather_class:constructor(payload)
    self.weather = payload.weather
    self.time = payload.time
    self.windSpeed = payload.windSpeed or 0.0
    self.windDirection = payload.windDirection or 0.0

    self.isRain = self:IsRain()
end

---Checks weather or not the current weather contains rain
---@return boolean
function weather_class:IsRain()
    return self.weather == 'RAIN' or self.weather == 'THUNDER'
end

---Sets the weather time to the given value.
---@param time number
function weather_class:SetEventTime(time)
    self.time = time
end

---Sets the weather to the given value.
---@param weather string
function weather_class:SetWeather(weather)
    self.weather = weather
    self.isRain = self:IsRain()
end

---Gets the weather data of the current weather event for the GlobalState
---@return renewed_weather_payload
function weather_class:GetWeatherData()
    return {
        weather = self.weather,
        time = self.time,
        windSpeed = self.windSpeed,
        windDirection = self.windDirection,
        isRain = self.isRain
    }
end

return weather_class