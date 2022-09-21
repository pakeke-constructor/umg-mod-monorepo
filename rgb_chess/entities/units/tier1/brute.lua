
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end

local DELTA_HEALTH = 4
local DELTA_DMG = 1

return extend("abstract_melee", {
    --[[
        on buy:
        gives a random [color] ally +1/4
    ]]

    defaultSpeed = 60,
    defaultHealth = 15,
    defaultAttackDamage = 4,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    onBuy = function(ent)
        local buffer = {}
        for _, e in rgb.iterUnits(ent.rgbTeam) do
            if e~=ent and rgb.areMatchingColors(e,ent)then
                table.insert(buffer, e)
            end
        end
        table.shuffle(buffer)
        local e = buffer[1]
        if e then
            buffAPI.buffHealth(e, DELTA_HEALTH, ent)
            buffAPI.buffDamage(e, DELTA_DMG, ent)
        end
    end;

    moveAnimation = {
        up = {"enemy_up_1", "enemy_up_2", "enemy_up_3", "enemy_up_4"},
        down = {"enemy_down_1", "enemy_down_2", "enemy_down_3", "enemy_down_4"}, 
        left = {"enemy_left_1", "enemy_left_2", "enemy_left_3", "enemy_left_4"}, 
        right = {"enemy_right_1", "enemy_right_2", "enemy_right_3", "enemy_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = base.entityHelper.initPosition

})

