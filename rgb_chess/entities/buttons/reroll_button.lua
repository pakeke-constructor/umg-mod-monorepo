


local reroll
if server then
    reroll = require("server.reroll")
end


return extend("abstract_button", {

    nametag = {
        value = "REROLL"
    },

    onClickServer = function(ent)
        reroll.reroll(ent.rgbTeam)
    end,

    init = function(ent, x, y)
        base.entityHelper.initPosition(ent,x,y)
    end
})


