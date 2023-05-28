
require("shared.constants")


local spellCardTypes = {--[[
    [cardSpellType] = { ... }
      string         options tabl
]]}


local newSpellCardTypeTc = typecheck.assert({
    name = "string",
    image = "string",
    cast = "function",
    description = "string",
    cost = "number",
    difficultyLevel = "number",
    rarity = "number?",
    minimumTurn = "number?"
})

local DEFAULT_MINIMUM_TURN = 1



local nameToSpellType = {}


function spellCardTypes.getSpell(spellType)
    return nameToSpellType[spellType]
end





local function newSpellCardType(options)
    newSpellCardTypeTc(options)
    nameToSpellType[options.name] = options
    options.rarity = options.rarity or constants.DEFAULT_RARITY
    options.minimumTurn = options.minimumTurn or DEFAULT_MINIMUM_TURN
    local diff = options.difficultyLevel
    assert(diff <= constants.MAX_DIFFICULTY_LEVEL and diff >= constants.MIN_DIFFICULTY_LEVEL, "?")
end




newSpellCardType({
    name = "0 of clubs",
    description = "Removes [color] from all shop cards",
    image = "0_of_clubs_card",
    cost = 3,
    rarity = 0.5,
    minimumTurn = 2,
    cast = function(board, rgbColor)
        board:getShopCards():map(function(cardEnt)
            local newRGB = rgb.subtract(cardEnt.rgb, rgbColor)
            rgbAPI.changeRGB(cardEnt, newRGB)
        end)
    end
})


newSpellCardType({
    name = "0 of clubs",
    description = "Removes [color] from all shop cards",
    image = "0_of_clubs_card",
    cost = 3,
    rarity = 0.5,
    minimumTurn = 2,
    cast = function(board, rgbColor)
        board:getShopCards():map(function(cardEnt)
            local newRGB = rgb.subtract(cardEnt.rgb, rgbColor)
            rgbAPI.changeRGB(cardEnt, newRGB)
        end)
    end
})






return spellCardTypes
