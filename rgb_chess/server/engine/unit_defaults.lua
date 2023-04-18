
--[[

Sets defaults for unit stats

attackDamage <- defaultAttackDamage
... etc

]]

local function makeDefaultsGroup(defaultComponent, targetComponent)
    local group = umg.group(defaultComponent)
    group:onAdded(function(ent)
        ent[targetComponent] = ent[defaultComponent]
    end)
end


makeDefaultsGroup("defaultAttackDamage", "attackDamage")
makeDefaultsGroup("defaultAttackSpeed", "attackSpeed")
makeDefaultsGroup("defaultSpeed", "speed")
makeDefaultsGroup("defaultSorcery", "sorcery")

