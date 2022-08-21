

local Board = base.Class("rgb_chess:board")



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
end


function Board:iterUnits()
    return ipairs(self.units)
end

return Board

