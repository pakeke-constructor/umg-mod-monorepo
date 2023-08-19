
require("control_events")


local RANGE_ACCEPTANCE = 80




sync.proxyEventToClient("control:entityClicked")


local getDimension = dimensions.getDimension


local function isInRange(ent, worldX, worldY, dimension)
    local dist = math.distance(ent.x - worldX, ent.y - worldY)
    return dist < RANGE_ACCEPTANCE and dimension == getDimension(ent)
end


local sf = sync.filters


if server then

server.on("entityClicked", {
    arguments = {sf.entity, sf.number, sf.number, sf.number, sf.string},
    handler = function(sender_uname, ent, button, worldX, worldY, dimension)
        if not (ent.onClick) then
            return
        end
        if button ~= 1 and button ~= 2 then
            return
        end
        if not isInRange(ent, worldX, worldY, dimension) then
            return
        end

        if type(ent.onClick) == "function" then
            ent:onClick(sender_uname, button, worldX, worldY)
        end
        umg.call("control:entityClicked", ent, sender_uname, button, worldX, worldY)
    end
})

else -- clientside:

local clickEnts = umg.group("x", "y", "onClick")
local listener = input.Listener({priority = 0})

function listener:mousepressed(mx, my, button, istouch, presses)
    -- TODO: This is kinda trash.
    -- this needs to be spatial partitioned probably.
    local worldX, worldY = rendering.toWorldCoords(mx, my)

    local bestDist = math.huge
    local bestEnt = nil

    for _, ent in ipairs(clickEnts) do
        local x, y = ent.x, rendering.getDrawY(ent.y, ent.z)
        local dist = math.distance(x-worldX, y-worldY)
        if dist < bestDist then
            if rendering.isHovered(ent) then
                bestEnt = ent
                bestDist = dist
            end
        end
    end

    if bestEnt then
        local camera = rendering.getCamera()
        local dimension = camera:getDimension()
        client.send("entityClicked", bestEnt, button, worldX, worldY, dimension)
        self:lockMouseButton(button)
    end
end

end




umg.on("control:entityClicked", function(ent, username, button, worldX, worldY)
    if type(ent.onClick) == "function" then
        ent:onClick(username, button, worldX, worldY)
    end
end)

