
local Board = require("server.board")



chat.handleCommand("spawnArmy", {
    adminLevel = 1,
    arguments = {},

    handler = function(sender)
        local p = base.getPlayer(sender)
        if not p then return end
        for i=1, 50 do
            local dx,dy = math.random(-200,200),math.random(-200,200)
            server.entities.brute(p.x+dx,p.y+dy)
        end
    end
})



local bruteGroup = umg.group("attackBehaviourTargetCategory")

chat.handleCommand("testHeal", {
    adminLevel = 1,
    arguments = {},

    handler = function(sender)
        for i=1, 20 do
            local ent = bruteGroup[math.random(bruteGroup:size())]
            rgbAPI.heal(ent, 1000)
            rgbAPI.shield(ent, 10, 2)
        end
    end
})



chat.handleCommand("spawnItems", {
    adminLevel = 1,
    arguments = {},

    handler = function(sender)
        local board = Board.getBoard(sender) 
        if board then
            board:generateItem()
        end
    end
})
