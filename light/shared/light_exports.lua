

local light = {}


local lightAPI
if client then
    lightAPI = require("client.light")
end



local rgbTc = typecheck.assert("number", "number", "number")

local function getColor(r,g,b)
    if type(r) == "table" then
        r,g,b = r[1],r[2],r[3]
    end
    rgbTc(r,g,b)
    return objects.Color(r,g,b)
end





if client then

light.setLightImage = lightAPI.setLightImage

function light.setDefaultLighting(r,g,b)
    local color = getColor(r,g,b)
    lightAPI.setDefaultLighting(color)
end

end



local setLightingTc = typecheck.assert("dimension")
function light.setLighting(dimension, r,g,b)
    --[[
        if called on clientSide:
            sets the lighting for a dimension.

        if called on serverSide:
            sets the lighting for a dimension,
            and syncs that lighting value with clients.
    ]]
    setLightingTc(dimension, r,g,b)
    local color = getColor(r,g,b)
    local overseerEnt = dimensions.getOverseer(dimension)
    if umg.exists(overseerEnt) then
        overseerEnt.lighting = color
        if server then
            sync.syncComponent(overseerEnt, "lighting")
        end
    end
end



umg.expose("light", light)

