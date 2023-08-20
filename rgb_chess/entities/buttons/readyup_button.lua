
local abstractButton = require("shared.abstract.abstract_button")



local readyUp
if server then
    readyUp = require("server.shop.ready_up")
end


local READY_NAMETAG = "READY UP"
local CANCEL_READY_NAMETAG = "CANCEL READY"



return umg.extend(abstractButton, {
    readyUpButton = true,

    onClickServer = function(ent)
        if not ent.rgb_is_ready then
            readyUp.readyUp(ent.rgbTeam)
        else
            readyUp.readyUpCancel(ent.rgbTeam)
        end
        ent.rgb_is_ready = not ent.rgb_is_ready
    end,

    onClickClient = function(ent)
        if ent.nametag.value == READY_NAMETAG then
            ent.nametag.value = CANCEL_READY_NAMETAG
        else
            ent.nametag.value = READY_NAMETAG
        end
    end,


    initXY = true,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "this ent needs to be assigned to an rgbTeam.")
        ent.nametag = {
            value = "READY UP"
        }
        ent.rgbTeam = rgbTeam
        ent.rgb_is_ready = false
    end
})


