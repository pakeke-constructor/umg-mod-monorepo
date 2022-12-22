
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end

local BUFFED_HP = 50
local BUFFED_DMG = 9

return umg.extend("abstract_melee", {
    --[[
        battle start:
        if no [color] allies exist,
        become a 9/50.
    ]]
    unitCardInfo = {
        name = "Squash x 1",
        description = "Battle start:\nIf no [color] allies exist, become a 9/50",
        cost = 1,
    };

    defaultSpeed = 60,
    defaultHealth = 10,
    defaultAttackDamage = 5,
    defaultAttackSpeed = 0.5,

    scaleY = 0.8,
    scaleX = 1.2,

    bobbing = {},

    onStartBattle = function(ent)
        for _, e in rgb.iterUnits(ent.rgbTeam) do
            if e~=ent and rgb.areMatchingColors(e,ent) then
                return
            end
        end
        -- else, we buff to be BIG:
        buffAPI.buffHealth(ent, BUFFED_HP - ent.maxHealth)
        buffAPI.buffHealth(ent, BUFFED_DMG - ent.attackDamage)
    end;

    moveAnimation = {
        up = {"mallow_up_1", "mallow_up_2", "mallow_up_3", "mallow_up_4"},
        down = {"mallow_down_1", "mallow_down_2", "mallow_down_3", "mallow_down_4"}, 
        left = {"mallow_left_1", "mallow_left_2", "mallow_left_3", "mallow_left_4"}, 
        right = {"mallow_right_1", "mallow_right_2", "mallow_right_3", "mallow_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = base.entityHelper.initPosition

})


