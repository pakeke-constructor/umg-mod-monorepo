

local moveBehaviourGroup = group("x", "y", "vx", "vy", "moveBehaviour", "speed")

local helper = require("server.helper")



local follow = {}
function follow.update(ent,dt)
    local targ = ent.moveBehaviourTarget
    helper.moveTo(ent, targ.x, targ.y)
end
function follow.heavyUpdate(ent,dt)
    helper.defaultHeavyUpdate(ent)
end




local circle = {}
local pi2 = math.pi*2
local CIRCLE_DEFAULT_PERIOD = 2
local CIRCLE_DEFAULT_RADIUS = 50
function circle.update(ent,dt)
    local targ = ent.moveBehaviourTarget
    local time = timer.getTime()
    local offset = ((ent.id % 10) / 10) * pi2
    local period = ent.moveBehaviour.circlePeriod or CIRCLE_DEFAULT_PERIOD
    local radius = ent.moveBehaviour.circleRadius or CIRCLE_DEFAULT_RADIUS
    local t = (time / pi2) * period + offset
    local x = radius * math.sin(t)
    local y = radius * math.cos(t)
    helper.moveTo(ent, targ.x + x, targ.y + y)
end
function circle.heavyUpdate(ent,dt)
    helper.defaultHeavyUpdate(ent)
end



local flee = {}
function flee.update(ent,dt)
    local targ = ent.moveBehaviourTarget
        --[[
        TODO::::
        Make it so the ent's velocity isnt instantaneously set.
        It's probably better to have some aspect of "agility" or something.
    ]]
    local dx,dy = ent.x - targ.x, ent.y - targ.y
    local mag = math.distance(dx,dy)
    if mag > 0 then
        ent.vx = (dx / mag) * ent.speed
        ent.vy = (dy / mag) * ent.speed
    else
        ent.vx = 0
        ent.vy = 0
    end
end
function flee.heavyUpdate(ent,dt)
    helper.defaultHeavyUpdate(ent)
end






local kite = {}
function kite.update(ent,dt)
    local targ = ent.moveBehaviourTarget
    helper.moveTo(ent, targ.x, targ.y)
end
function kite.heavyUpdate(ent,dt)
    helper.defaultHeavyUpdate(ent)
end





local none = {}
function none.update(ent,dt)
end
function none.heavyUpdate(ent,dt)
end




local moveBehaviours = {
    follow=follow,
    circle=circle,
    kite=kite,
    none=none
}





on("update60", function(dt)
    for _, ent in ipairs(moveBehaviourGroup)do
        local mb = ent.moveBehaviour
        if not (moveBehaviours[mb.type]) then 
            error("invalid movebehaviour: " .. mb.type)
        end
        moveBehaviours[mb.type].heavyUpdate(ent,dt)
    end
end)



on("update", function(dt)
    for _, ent in ipairs(moveBehaviourGroup) do
        local mb = ent.moveBehaviour
        if not (moveBehaviours[mb.type]) then 
            error("invalid movebehaviour: " .. mb.type)
        end
        moveBehaviours[mb.type].update(ent,dt)
    end
end)

