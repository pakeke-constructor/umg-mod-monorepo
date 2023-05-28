
local cardAPI = {}

local spellCardTypes = require("shared.cards.card_types")



local castSpellTc = typecheck.assert("string", "table", "table")


function cardAPI.playSpellCard(cardSpellType, board, rgb)
    castSpellTc(cardSpellType, board, rgb)
    local spell = spellCardTypes.getSpell(cardSpellType)
    assert(spell, "undefined spell: " .. cardSpellType)
    spell.cast(board, rgb)
end


return cardAPI

