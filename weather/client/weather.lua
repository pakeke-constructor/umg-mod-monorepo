

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




--[[
TODO: Currently, these paramaters don't actually do anything.

We need to have a component, (perhaps `weatherUpdate` component?)
That listens to changes in weather, and adjusts accordingly.

FROM PLANNING.md:
The current effects are determined by these three parameters:
Wetness:  0 --> 1
Sunniness: 0 --> 1
Cloudiness:  0 --> 1
Windiness: -1 --> 1


And here are the calculations for how  the weather should be determined:

Fog  =  +Cloudyness  +Wetness  -abs(Windiness)  -Sunniness/2
CloudShadow  =  +Cloudyness +Sunniness
Rain  =  +Cloudiness  +Raininess  +Wetness  -Sunniness
WindEffect  =  +abs(Windiness)  +Sunniness
SunBeam  =  +Sunniness

]]
function weather.setWeatherState(wstate)
    wstate = table.copy(wstate)
    for key,val in pairs(weatherState) do
        wstate[key] = wstate[key] or val
    end
    assertWeatherStateValid(wstate)
    weatherState = wstate
end



weather.rain = rain

