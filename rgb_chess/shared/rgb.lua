
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




local function not_xor(a,b)
    return ((a>0) and (b>0)) or ((a==0) and (b==0))
end

function rgb.getColorString(rgbColor)
    --[[
        returns the name of the color, as a string.
    ]]
    for col, tabl in pairs(rgb.COLS) do
        local rOk = not_xor(tabl[1], rgbColor[1])
        local gOk = not_xor(tabl[2], rgbColor[2])
        local bOk = not_xor(tabl[3], rgbColor[3])
        if rOk and gOk and bOk then
            return col
        end
    end
    return "BLK"
end


function rgb.match(col1, col2)
    if col1.rgb and col2.rgb then
        local ent1, ent2 = col1, col2
        return rgb.match(ent1.rgb, ent2.rgb)
    end

    local r = col1[1]*col2[1]
    local g = col1[2]*col2[2]
    local b = col1[3]*col2[3]

    return (r+g+b) > 0
end


function rgb.sameTeam(obj1, obj2)
    local team1 = umg.exists(obj1) and obj1.rgbTeam or obj1
    local team2 = umg.exists(obj2) and obj2.rgbTeam or obj2
    return team1 == team2 
end




rgb.cardTypes = base.Enum({
    UNIT = "UNIT",
    SPELL = "SPELL",
    ITEM = "ITEM"
})



function rgb.getDamageEstimate(attackDamage, attackSpeed)
    return attackDamage * attackSpeed
end


function rgb.generatePVEEnemyTeam(rgbTeam)
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


function rgb.iterUnits(rgbTeam)
    assert(rgbTeam, "rgb.iterUnits not given rgbTeam")
    return ipairs(categories.getSet(rgbTeam))
end



function rgb.getSquadronCount(rgbTeam)
    local seenEntities = {}
    local count = 0
    for _, ent in rgb.iterUnits(rgbTeam)do
        if not seenEntities[ent] then
            seenEntities[ent] = true
            if ent.squadron then
                for _, e in ipairs(ent.squadron) do
                    seenEntities[e] = true
                end
            end
            count = count + 1
        end
    end
    return count
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
function rgb.changeRGB(ent, newRGB)
    if rgb.match(ent.rgb, newRGB) then
        ent.rgb = newRGB
        return
    else
        ent.rgb = newRGB
        server.broadcast("swapRGB", ent, newRGB)
        umg.call("swapRGB", ent, newRGB)
    end
end
else
client.on("swapRGB", function(ent, newRGB)
    ent.rgb = newRGB
    umg.call("swapRGB", ent, newRGB)
end)
end



if server then
    local Board = require("server.board")

    function rgb.iterShop(rgbTeam)
        assert(rgbTeam, "rgb.iterShop not given rgbTeam")
        local board = Board.getBoard(rgbTeam)
        return ipairs(board.shop)
    end

    function rgb.setState(state)
        assert(states_invert[state], "invalid state")
        rgb.state = state
        server.broadcast("setRGBState", state)
    end

    function rgb.setMoney(rgbTeam, x)
        local board = Board.getBoard(rgbTeam)
        board:setMoney(x)
    end

    function rgb.getMoney(rgbTeam)
        local board = Board.getBoard(rgbTeam)
        return board:getMoney()
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


