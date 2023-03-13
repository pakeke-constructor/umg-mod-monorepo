

local rain = require("client.rain")



local weather = {}


local weatherState = {
    wetness = 0,
    sunniness = 1,
    cloudiness = 0.4,
    windiness = 0.2,
    raininess = 0
}


function weather.getWeatherState()
    return weatherState
end



local function assertInRange01(field, x)
    if type(x) ~= "number" then
        error(field .. " needs to be a number in range 0, 1")
    end
    if x > 1 or x < 0 then
        error(field .. " needs to be between 0 and 1")
    end
end


local function assertWeatherStateValid(state)
    assertInRange01("wetness", state.wetness)
    assertInRange01("sunniness", state.sunniness)
    assertInRange01("cloudiness", state.cloudiness)
    assertInRange01("windiness", math.abs(state.windiness))
    assertInRange01("raininess", state.raininess)
end


function weather.setWeatherState(wstate)
    wstate = table.copy(wstate)
    for key,val in pairs(weatherState) do
        wstate[key] = wstate[key] or val
    end
    assertWeatherStateValid(wstate)
    weatherState = wstate
end

