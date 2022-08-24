

local Board = base.Class("rgb_chess:board")

local usernameToBoard = {
--[[
    [username] = Board
]]
}




-- Static method:
function Board.getBoard(username)
    return usernameToBoard[username]
end


function Board.iterBoards()
    return pairs(usernameToBoard)
end




function Board:init(x, y, owner)
    self.x = x
    self.y = y

    self.money = 0

    self.shopSize = 5
    self.shop = {--[[card1, card2, ... ]]}
    self.shopLocks = {--[[
        [shopIndex] = true/false
        tells what shop items are locked
    ]]}

    self.owner = owner

    self.units = {--[[
        ent1, ent2, ...
    ]]}

    -- Only used during battle.
    self.enemies = {--[[
        enemy1, enemy2, enemy3
    ]]}

    self.turn = 0

    usernameToBoard[owner] = self
end



function Board:delete()
    usernameToBoard[self.owner] = nil
end


function Board:iterUnits()
    return ipairs(self.units)
end



function Board:serialize()
    -- serializes the allies on the board
    self.serialized = serialize(self.units)
end



function Board:reset()
    -- puts allies back onto the board, (deserialized)
    local arr, err = deserialize(self.serialized)
    if (not arr) and err then
        print("[rgb_chess]: error in deserializing allies for board: ", err)
    end
    for i=1, #arr do
        local ally = arr[i]
        ally.attackBehaviourTargetCategory = nil
    end
    self.units = arr
end



function Board:clear()
    --[[
        deletes all units on the board.
    ]]
    for i=1, #self.units do
        local ent = self.units[i]
        ent:delete()
    end
    for i=1, #self.enemies do
        local ent = self.enemies[i]
        ent:delete()
    end
end


function Board:putEnemies(data)
    --[[
        puts enemies on the board
        TODO: Make particle effects and stuff here
    ]]
    local arr, err
    if type(data) == "string" then
        arr, err = deserialize(data)
        if (not arr) and err then
            print("[rgb chess]: Unable to deserialize enemy data:", err)
            return
        end
    else
        arr = data
    end

    local enemyCategory = arr[1] and arr[1].category
    for i=1, #arr do
        local ent = arr[i]
        ent.attackBehaviourTargetCategory = self.owner
        table.insert(self.enemies, ent)
    end

    for i=1, #self.units do
        self.units[i].attackBehaviourTargetCategory = enemyCategory
    end
end



return Board

