

local buffAPI = {}




function buffAPI.buffHealth(ent, amount, source_ent, buffdepth)
    entities.buff_hp(ent, amount, source_ent, buffdepth)
end


function buffAPI.buffDamage(ent, amount, source_ent, buffdepth)
    entities.buff_dmg(ent, amount, source_ent, buffdepth)
end


function buffAPI.buffAttackSpeed(ent, amount, source_ent, buffdepth)
    entities.buff_atkspd(ent, amount, source_ent, buffdepth)
end


function buffAPI.buffSpeed()
    error("nyi")
end



return buffAPI

