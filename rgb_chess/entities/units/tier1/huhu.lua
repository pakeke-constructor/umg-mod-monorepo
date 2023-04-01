

local buffAPI
if server then
    buffAPI = require("server.buffapi")
end


return umg.extend("abstract_melee", {
    --[[
        on sell:
        grants all other [color] huhus x2 damage and x2 health
    ]]
    "squadron_buff_done",

    unitCardInfo = {
        name = "Huhu x 3",
        description = "On sell:\nDouble all [color] huhus damage and health",
        cost = 2,
        squadronSize = 3,
    };

    defaultSpeed = 70,
    defaultHealth = 3,
    defaultAttackDamage = 1,
    defaultAttackSpeed = 0.4,

    animation = {
        frames = {"huhu1","huhu2","huhu3","huhu2"}, 
        speed=0.6
    };

    onSell = function(ent)
        if ent.squadron_buff_done then return end

        for _, e in rgb.iterUnits(ent.rgbTeam) do
            if e~=ent and rgb.areMatchingColors(e,ent) and e:type() == ent:type() then
                local dmg, health = e.attackDamage, e.maxHealth
                buffAPI.buffHealth(e, health, ent)
                buffAPI.buffDamage(e, dmg, ent)
            end
        end

        for _, e in ipairs(ent.squadron) do
            -- we only want to buff once.
            e.squadron_buff_done = true
        end
    end;

    init = base.initializers.initXY

})


