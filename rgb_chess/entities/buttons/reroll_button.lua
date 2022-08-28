

local frames = {1,2,3,4,5,4,3,2,1}
for i=1, #frames do
    frames[i] = "button" .. tostring(i)
end


local reroll, Board
if server then
    Board = require("server.board")
    reroll = require("server.reroll")
end


return {
    "x", "y", "rgbTeam",
    image = "button1",

    onClick = function(ent, username, button)
        if button == 1 and username == ent.rgbTeam then
            if client then
                -- TODO: play sound here
                base.animateEntity(ent, frames, 0.35)
            else
                local board = Board.getBoard(ent.rgbTeam)
                reroll.reroll(board)
            end
        end
    end,

    nametag = {

    },

    init = function(ent, x, y)
        base.entityHelper.initPosition(ent,x,y)
    end
}


