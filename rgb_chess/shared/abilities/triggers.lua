
require("shared.constants")


local triggers = {}


local triggerTypeToDescription = {
    allyDeath = "Ally dies:", -- done
    -- "enemyDeath", NYI

    allyBuff = "Ally is buffed:", -- done
    allyDebuff = "Ally is debuffed:", -- done

    allySummoned = "Ally is summoned:", -- done
    allySold = "Ally is sold:", -- done
 
    allyDamage = "Ally takes damage:", -- done
    allyHeal = "Ally is healed:", -- done
    allyAttack = "Ally attacks:", -- done

    -- Stun system NYI.
    -- allyStun = "ally is stunned:", 

    allyShieldBreak = "Ally's shield breaks:", -- done
    allyShieldExpire = "Ally's shield expires:", -- done
 
    reroll = "On reroll:", -- done
    startTurn = "On turn start:", -- done
    endTurn = "On turn end:", -- done

    startBattle = "On battle start:", -- done
    endBattle = "On battle end:", -- done

    cardBought = "Card is purchased:", -- done

    allyChangeColor = "Ally changes color:", -- done
    allyChangeAbility = "Ally changes abilities:", -- done

    allyLevelUp = "Ally levels up:", -- done
    allyLevelDown = "Ally levels down:" -- 

    allyAbility = "Ability activates:", -- done
    selfAbility = "entity activates it's own ability:" -- done
}



local stringTc = typecheck.assert("string")
local textArg = {Color = constants.ABILITY_UI_COLORS.TRIGGER}

function triggers.drawSlabUI(triggerType)
    stringTc(triggerType)
    local desc = triggerTypeToDescription[triggerType]
    assert(desc, "invalid triggertype: " .. triggerType)

    Slab.Text("Trigger: ", textArg)
    Slab.SameLine()
    Slab.Text(desc)
end




function triggers.isValid(triggerType)
    stringTc(triggerType)
    return triggerTypeToDescription[triggerType]
end



function triggers.getAllTriggerTypes()
    local buf = base.Array()
    for trigger, _ in pairs(triggerTypeToDescription)do
        buf:add(trigger)
    end
    return buf
end



return triggers
