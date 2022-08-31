

local readyUp
if server then
    readyUp = require("server.reroll")
end


return extend("abstract_button", {
    nametag = {
        value = "READY UP"
    },

    onClickServer = function(ent)
    end,

    init = function(ent, x, y)
        base.entityHelper.initPosition(ent,x,y)
    end
})


