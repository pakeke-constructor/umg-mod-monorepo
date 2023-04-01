
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end

local HP_LOST = 3


return umg.extend("abstract_melee", {
    --[[
        on turn start:
        lose 3 health
    ]]
    unitCardInfo = {
        name = "Tanko x 1",
        description = "Turn start:\nThis unit loses 3 max hp",
        cost = 1,
    };

    defaultSpeed = 60,
    defaultHealth = 10,
    defaultAttackDamage = 5,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    onStartTurn = function(ent)
        buffAPI.debuffHealth(ent, HP_LOST)
    end;

    moveAnimation = {
        up = {"mallow_up_1", "mallow_up_2", "mallow_up_3", "mallow_up_4"},
        down = {"mallow_down_1", "mallow_down_2", "mallow_down_3", "mallow_down_4"}, 
        left = {"mallow_left_1", "mallow_left_2", "mallow_left_3", "mallow_left_4"}, 
        right = {"mallow_right_1", "mallow_right_2", "mallow_right_3", "mallow_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = base.initializers.initXY

})
