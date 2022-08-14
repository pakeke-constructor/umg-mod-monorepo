

local function attack(ent, targ)
    if server then
        server.broadcast("attack", ent, targ)
    end
end


local function update(ent, targ)
    local time = timer.getTime()
    local last_atck = ent.rgb_last_attack or time

    local attackRate = ent.attackRate
    assert(type(attackRate) == "number", "entity not given attackRate value")

    local dt = time - last_atck
    if dt > attackRate then
        ent.rgb_last_attack = 
    end
end


local function extendAsAttacker(ent_definition, range, attackCb)
    ent_definition.proximity = {
        update = update
    }
end



