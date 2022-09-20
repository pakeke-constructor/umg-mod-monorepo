
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end


local brute = extend("abstract_melee", {

    defaultSpeed = 60,
    defaultHealth = 10,
    defaultAttackDamage = 5,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    onBuy = function(ent)
        for _, e in rgb.iterUnits(ent.rgbTeam) do
            if e~=ent and rgb.areMatchingColors(e,ent)then
                buffAPI.buffHealth(e, 2, ent)
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


return brute

