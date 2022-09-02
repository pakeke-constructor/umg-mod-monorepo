


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

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "need to pass in rgbTeam")
        base.entityHelper.initPosition(ent,x,y)
        ent.rgbTeam = rgbTeam
    end
})


