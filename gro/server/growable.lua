

local growableEntities = group("x", "y", "growable")



local last_tick = timer.getTime()



growableEntities:onAdded(function(ent)
    if not ent:isRegular("growStage") then
        error("Growable entities require growStage component. Not the case for this ent: " .. tostring(ent:type()))
    end
    if not ent:hasComponent("image") then
        error("Growable entities require an image component. Not the case for ".. ent:type())
    end
    if not ent.growStage then
        ent.growStage = 0
    end

    if ent.growable.stages then
        if not ent.image then
            ent.image = ent.growable.stages[1]
        end
    end

    if ent.growable.minScale then
        if not ent:isRegular("scale") then
            error("growable entities that scale require a .scale component. Not the case for " .. ent:type())
        end
    end
end)


local curTime = timer.getTime()

on("gameUpdate", function(dt)
    local time = curTime + dt
    local dtt = time - last_tick
    if dtt > 1 then
        last_tick = time + (dtt-1)
        call("growStep")
        -- `growStep` is called once every second.
    end
end)




local function grow(ent)
    -- We don't need `dt` here, as this is guaranteed to be called every second.
    local growRate = 1 / ent.growable.time
    ent.growStage = math.min(1, ent.growStage + growRate)
    if ent.growable.stages then
        -- its a plant that changes image
        local len = #ent.growable.stages
        local i = math.min(math.floor((ent.growStage * (len-1)) + 1.02), len)
        if ent.image ~= ent.growable.stages[i] then
            -- then we grow the plant!
            ent.image = ent.growable.stages[i]
            server.broadcast("changeGrowImage", ent, i)
        end
    else
        -- it's a scaling plant
        if (type(ent.growable.minScale) ~= "number") or (type(ent.growable.maxScale) ~= "number") then
            error("growable scaling entities must have growable.maxScale and growable.minScale values.\nNot the case for: " .. ent:type())
        end
        local dScale = ent.growable.maxScale - ent.growable.minScale
        ent.scale = math.min(ent.minScale + ent.growStage * dScale, ent.maxScale)
    end
end


on("growStep", function()
    for _, ent in ipairs(growableEntities)do
        grow(ent)
    end
end)


