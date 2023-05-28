
require("shared.constants")


local rgb = {}

rgb.COLS = {
    RED = {1,0,0};
    GRN = {0,1,0};
    BLU = {0,0,1};

    YLO = {1,1,0};
    AQU = {0,1,1};
    MAG = {1,0,1};

    WHI = {1,1,1};

    BLK = {0,0,0};
}

setmetatable(rgb.COLS, {__index = function(_,k) error("invalid color: " .. tostring(k)) end})




local EPSILON = 0.01 -- any value lower than this, 
-- means that the color component is non-existant.

local function componentMatch(a,b)
    return ((a>EPSILON) and (b>EPSILON)) or ((a<=EPSILON) and (b<=EPSILON))
end


function rgb.exactMatch(col1, col2)
    if col1.rgb and col2.rgb then
        local ent1, ent2 = col1, col2
        return rgb.exactMatch(ent1.rgb, ent2.rgb)
    end

    local rOk = componentMatch(col1[1], col2[1])
    local gOk = componentMatch(col1[2], col2[2])
    local bOk = componentMatch(col1[3], col2[3])

    return rOk and gOk and bOk
end



function rgb.invert(color)
    for _, invertCandidate in pairs(rgb.COLS) do
        local rOk = componentMatch(color[1], invertCandidate[1])
        local gOk = componentMatch(color[2], invertCandidate[2])
        local bOk = componentMatch(color[3], invertCandidate[3])
        if (not rOk) and (not gOk) and (not bOk) then
            return invertCandidate
        end
    end
end



function rgb.getColorString(rgbColor)
    --[[
        returns the name of the color, as a string.
    ]]
    for col, tabl in pairs(rgb.COLS) do
        if rgb.exactMatch(rgbColor, tabl) then
            return col
        end
    end
    return "BLK"
end


function rgb.rgbToColor(rgbColor)
    --[[
        converts an rgb color into a color that is adequate for displaying
        (i.e. isn't too dark)
    ]]
    local cpy = {}
    for i=1, 3 do
        cpy[i] = math.max(constants.CARD_LIGHTNESS, rgbColor[i])
    end
    return cpy
end






function rgb.match(col1, col2)
    if col1.rgb and col2.rgb then
        local ent1, ent2 = col1, col2
        return rgb.match(ent1.rgb, ent2.rgb)
    end

    local r = col1[1]*col2[1]
    local g = col1[2]*col2[2]
    local b = col1[3]*col2[3]

    return (r+g+b) > EPSILON
end


function rgb.getCardinality(col)
    --[[
    gets the cardinality of a color; how many color components it has
    
    RED cardinality 1
    WHI cardinality 3
    BLK cardinality 0
    AQU cardinality 2        
    ]]
    return math.round(col[1] + col[2] + col[3])
end


function rgb.isBlack(col)
    return (rgb.cardinality(col)) < EPSILON 
end



local addSubTc = typecheck.assert("table", "table")

function rgb.subtract(col, sub)
    addSubTc(col,sub)
    return {
        math.max(0, col[1] - sub[1]),
        math.max(0, col[2] - sub[2]),
        math.max(0, col[3] - sub[3])
    }
end

function rgb.add(col, add)
    addSubTc(col,add)
    return {
        math.min(1, col[1] + add[1]),
        math.min(1, col[2] + add[2]),
        math.min(1, col[3] + add[3])
    }
end



function rgb.sameTeam(obj1, obj2)
    local team1 = umg.exists(obj1) and obj1.rgbTeam or obj1
    local team2 = umg.exists(obj2) and obj2.rgbTeam or obj2
    return team1 == team2 
end



local getDamageEstimateTc = typecheck.assert("number", "number")

-- used for MELEE and RANGED unit types. sorcerers dont care about this.
function rgb.getDamageEstimate(power, attackSpeed)
    getDamageEstimateTc(power, attackSpeed)
    return power * attackSpeed
end


function rgb.getPVEEnemyTeamName(rgbTeam)
    -- generates a team ID for use by PVE enemies
    return constants.PVE_PREFIX .. rgbTeam
end


function rgb.setTeam(ent, rgbTeam)
    --  sets a team for an entity
    if ent.rgbTeam ~= rgbTeam and ent.rgbTeam then
        error("Entity teams should be constant.")
    end
    ent.rgbTeam = rgbTeam
    categories.changeEntityCategory(ent, rgbTeam)
end


function rgb.setTarget(ent, rgbTeam)
    -- sets a target for an entity
    ent.moveBehaviourTargetCategory = rgbTeam
    ent.attackBehaviourTargetCategory = rgbTeam
end



function rgb.isRanged(ent)
    return ent.attackBehaviour and ent.attackBehaviour.type == "ranged"
end



function rgb.getMaxSquadrons()
    return rgb.getTurn() + constants.SQUADRON_COUNT_INCREMENT
end



function rgb.isUnit(ent)
    -- returns true if ent is a unit entity
    return ent.rgbUnit
end


function rgb.isSorcerer(ent)
    return rgb.isUnitOfType(ent, constants.UNIT_TYPES.SORCERER)
end

function rgb.isUnitOfType(ent, enum)
    return rgb.isUnit(ent) and ent.unitType == enum
end

function rgb.isAttacker(ent)
    local melee = constants.UNIT_TYPES.MELEE
    local ranged = constants.UNIT_TYPES.RANGED
    return rgb.isUnitOfType(ent, melee) or rgb.isUnitOfType(ent, ranged)
end




function rgb.isCardOfType(cardEnt, enum)
    assert(constants.CARD_TYPES[enum], "?")
    local buyTarget = cardEnt.cardBuyTarget
    assert(buyTarget, "not a card entity")
    local cardInfo = buyTarget.cardInfo
    return cardInfo.type == enum
end

function rgb.isUnitCard(cardEnt)
    return rgb.isCardOfType(cardEnt, constants.CARD_TYPES.UNIT)
end

function rgb.isSpellCard(cardEnt)
    return rgb.isCardOfType(cardEnt, constants.CARD_TYPES.SPELL)
end




function rgb.isItem(ent)
    return ent.itemName
end

function rgb.isItemOfType(ent, enum)
    return rgb.isItem(ent) and ent.itemType == enum
end

function rgb.isPassiveItem(ent)
    return rgb.isItemOfType(ent, constants.ITEM_TYPES.PASSIVE)
end

function rgb.isUsableItem(ent)
    return rgb.isItemOfType(ent, constants.ITEM_TYPES.USABLE)
end





rgb.STATES = base.Enum({
    LOBBY_STATE = "LOBBY_STATE",
    BATTLE_STATE = "BATTLE_STATE",
    TURN_STATE = "TURN_STATE"
}) 


local states_invert = {}
for k,v in pairs(rgb.STATES)do states_invert[v] = k end

rgb.state = rgb.STATES.LOBBY_STATE


function rgb.getState()
    return rgb.state 
end


rgb.turn = 1

function rgb.getTurn()
    return rgb.turn
end





if server then
    local Board -- we need to require at runtime to avoid circular dependency

    function rgb.getBoard(rgbTeam)
        if not Board then
            Board = require("server.board")
        end
        return Board.getBoard(rgbTeam)
    end

    function rgb.setState(state)
        assert(states_invert[state], "invalid state")
        rgb.state = state
        server.broadcast("setRGBState", state)
    end

    function rgb.increaseTurnCount()
        rgb.turn = rgb.turn + 1
        server.broadcast("setRGBTurnCount", rgb.turn)
    end
else
    client.on("setRGBState", function(state)
        rgb.state = state
    end)

    client.on("setRGBTurnCount", function(tc)
        rgb.turn = tc
    end)
end


umg.expose("rgb", rgb)
_G.rgb = rgb


