
local buffAPI
if server then
    buffAPI = require("server.buffapi")
end

local HEALTH_BUFF_AM = 1
local DMG_BUFF_AM = 1


return extend("abstract_ranged", {
    --[[
        on ally summoned:
        if ally is [color], give ally 1/1
    ]]
    unitCardInfo = {
        name = "Enhancer",
        description = "On ally summon:\nIf ally is [color], give ally +1/1",
        cost = 1
    };

    defaultSpeed = 50,
    defaultHealth = 3,
    defaultAttackDamage = 2,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    onAllySummoned = function(ent, summoned_ent)
        if rgb.areMatchingColors(ent, summoned_ent) then
            buffAPI.buffHealth(summoned_ent, HEALTH_BUFF_AM, ent)
            buffAPI.buffAttackDamage(summoned_ent, DMG_BUFF_AM, ent)
        end
    end;

    moveAnimation = {
        up = {"wizard_up_1", "wizard_up_2"},
        down = {"wizard_down_1", "wizard_down_2"}, 
        left = {"wizard_left_1", "wizard_left_2"}, 
        right = {"wizard_right_1", "wizard_right_2"},
        speed = 0.7;
        activation = 15
    };

    init = base.entityHelper.initPosition
})

