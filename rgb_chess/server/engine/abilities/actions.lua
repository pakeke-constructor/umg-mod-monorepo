

local actions = {}

local Action = base.Class("rgb-chess:Action")


local nameToAction = {--[[
    [name] = Action
]]}


function actions.getAction(name)
    return nameToAction[name]
end



function Action:init(options)
    assert(options.name, "?")
    assert(options.action, "?")
    assert(options.description, "?")
    local tdes = type(options.description)
    assert(tdes == "string" or tdes == "function", "?")

    assert(not nameToAction[options.name], "duplicate action def")
    nameToAction[options.name] = self

    for k,v in pairs(options)do
        self[k] = v
    end
end



local drawSlabUITc = typecheck("table", "number")

function Action:drawSlabUI(level)
    drawSlabUITc(self, level)

    local txt = self.description
    if type(txt) == "function" then
        txt = self.description(level)
    end
    Slab.Text(txt)
end


function Action:apply(...)
    self.action(...)
end




local HEAL_FACTOR = 4

Action({
    name = "heal",
    action = function(sourceEnt, targetEnt, level, depth)
        rgbAPI.heal(targetEnt, level * HEAL_FACTOR, sourceEnt, depth)
    end,
    description = function(level)
        return "Heal for " .. HEAL_FACTOR * level
    end
})



local SHIELD_DURATION = 3
local SHIELD_FACTOR = 5

Action({
    name = "shield",
    action = function(sourceEnt, targetEnt, level, depth)
        rgbAPI.shield(targetEnt, level * SHIELD_FACTOR, SHIELD_DURATION,sourceEnt, depth)
    end,
    description = function(level)
        return "Shield for " .. SHIELD_FACTOR * level
    end
})




local buffTypes = {
    ATTACK_DAMAGE = "AttackDamage",
    ATTACK_SPEED = "AttackSpeed",
    SPEED = "Speed",
    HEALTH = "Health",
    SORCERY = "Sorcery",
}

for magnitude = 1, 4 do
    for buffEnum, abilitySuffix in pairs(buffTypes)do
        Action({
            name = "buff" .. tostring(abilitySuffix) .. tostring(magnitude),
            action = function(sourceEnt, targetEnt, level, depth)
                local bType = constants.BUFF_TYPES[buffEnum]
                local amount = level * magnitude
                rgbAPI.buff(targetEnt, bType, amount, sourceEnt, depth)
            end,
            description = function(level)
                local amount = level * magnitude
                return "Buff " .. abilitySuffix .. " for " .. tostring(amount)
            end
        })
    end
end


Action({
    name = "reroll",
    action = function(sourceEnt, targetEnt, level, depth)
        local board = rgb.getBoard(targetEnt.board)
        board:reroll()
    end,
    description = "Rerolls shop"
})



return actions
