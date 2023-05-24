

local triggers = {}


local triggerTypeToDescription = {
    allyDeath = "When an ally dies:", -- done
    -- "enemyDeath", NYI

    allyBuff = "When an ally is buffed:", -- done
    allyDebuff = "When an ally is debuffed:", -- done

    allySummoned = "When an ally is summoned:", -- done
    allySold = "When an ally is sold:", -- done
 
    allyDamage = "When an ally takes damage:", -- done
    allyHeal = "When an ally is healed:", -- done
    allyAttack = "When an ally attacks:", -- done

    -- Stun system NYI.
    -- allyStun = "When an ally is stunned:", 

    allyShieldBreak = "When an ally's shield breaks:", -- done
    allyShieldExpire = "When an ally's shield expires:", -- done
 
    reroll = "On reroll:", -- done
    startTurn = "On turn start:", -- done
    endTurn = "On turn end:", -- done

    startBattle = "On battle start:", -- done
    endBattle = "On battle end:", -- done

    cardBought = "When a card is purchased:", -- done

    allyChangeColor = "When an ally changes color:",

    allyAbility = "When an ability activates:", -- done
    selfAbility = "When an entity activates it's own ability:" -- done
}



local stringTc = typecheck.assert("string")

function triggers.drawSlabUI(triggerType)
    stringTc(triggerType)
    local desc = triggerTypeToDescription[triggerType]
    assert(desc, "invalid triggertype: " .. triggerType)

    Slab.Text("Trigger: ")
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
