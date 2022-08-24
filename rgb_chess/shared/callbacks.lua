

on("attack", function(atcker_ent, targ_ent, dmg)
    if targ_ent.onDamage then
        targ_ent:onDamage(atcker_ent, dmg)
    end
    if atcker_ent.onAttack then
        atcker_ent:onAttack(targ_ent, dmg)
    end
end)





on("startBattle", function()

end)





