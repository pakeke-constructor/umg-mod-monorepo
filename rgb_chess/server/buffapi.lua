

local buffAPI = {}


local BUFF_TYPES = constants.BUFF_TYPES

--(@@@ent@@, target_ent, buff_type, buff_amount, source_ent, depth)

function buffAPI.buffHealth(ent, amount, source_ent, buffdepth)
    local e = entities.buff(ent, BUFF_TYPES.HEALTH, amount, source_ent, buffdepth)
    e.color = {0.7,0.7,0.2}
end


function buffAPI.buffDamage(ent, amount, source_ent, buffdepth)
    local e = entities.buff(ent, BUFF_TYPES.ATTACK_DAMAGE, amount, source_ent, buffdepth)
    e.color = {0.5,0.9,0.3}
end


function buffAPI.buffAttackSpeed(ent, amount, source_ent, buffdepth)
    local e = entities.buff(ent, BUFF_TYPES.ATTACK_SPEED, amount, source_ent, buffdepth)
    e.color = {0.7,0.7,0.2}

end


function buffAPI.buffSpeed(ent, amount, source_ent, buffdepth)
    local e = entities.buff(ent, BUFF_TYPES.SPEED, amount, source_ent, buffdepth)
    e.color = {0.2,0.2,0.7}
end












function buffAPI.debuffHealth(ent, amount, source_ent, buffdepth)
    local e = entities.debuff(ent, BUFF_TYPES.HEALTH, amount, source_ent, buffdepth)
    e.color = {0.3,0.3,0}
end


function buffAPI.debuffDamage(ent, amount, source_ent, buffdepth)
    local e = entities.debuff(ent, BUFF_TYPES.ATTACK_DAMAGE, amount, source_ent, buffdepth)
    e.color = {0.2,0.4,0}
end


function buffAPI.debuffAttackSpeed(ent, amount, source_ent, buffdepth)
    local e = entities.debuff(ent, BUFF_TYPES.ATTACK_SPEED, amount, source_ent, buffdepth)
    e.color = {0.3,0.3,0}

end


function buffAPI.debuffSpeed(ent, amount, source_ent, buffdepth)
    local e = entities.debuff(ent, BUFF_TYPES.SPEED, amount, source_ent, buffdepth)
    e.color = {0,0,0.4}
end










return buffAPI

