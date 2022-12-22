
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end


local BUFF_AMOUNT = 2


return umg.extend("abstract_melee", {
    --[[
        on turn start:
        grant all ranged [color] allies +2 dmg
    ]]
    unitCardInfo = {
        name = "Hoodlum x 1",
        description = "On turn start:\nGive all ranged [color] allies +2 damage",
        cost = 1
    };

    defaultSpeed = 55,
    defaultHealth = 8,
    defaultAttackDamage = 3,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    onBuy = function(ent)
        for _, e in rgb.iterUnits(ent.rgbTeam) do
            if e~=ent and rgb.areMatchingColors(e,ent)then
                if rgb.isRanged(e) then
                    buffAPI.buffDamage(e, BUFF_AMOUNT, ent)
                end
            end
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

