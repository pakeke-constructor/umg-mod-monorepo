

local showDetails
if client then
    showDetails = require("client.show_details")
end


local SHOWING_TAG = "HIDE STATS"
local NOT_SHOWING_TAG = "SHOW STATS"


return umg.extend("abstract_button", {
    "nametag",

    onClickClient = function(ent)
        if ent.nametag.value == SHOWING_TAG then
            showDetails.hideDetails()
            ent.nametag.value = NOT_SHOWING_TAG
        else
            showDetails.showDetails()
            ent.nametag.value = SHOWING_TAG
        end
    end,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "this ent needs to be assigned to an rgbTeam.")
        ent.nametag = {
            value = NOT_SHOWING_TAG
        }
        ent.rgbTeam = rgbTeam
        base.entityHelper.initPosition(ent,x,y)
    end
})


