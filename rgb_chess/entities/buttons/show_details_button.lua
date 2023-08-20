
local abstractButton = require("shared.abstract.abstract_button")


local showDetails
if client then
    showDetails = require("client.shop.show_details")
end


local SHOWING_TAG = "HIDE STATS"
local NOT_SHOWING_TAG = "SHOW STATS"


return umg.extend(abstractButton, {
    onClickClient = function(ent)
        if showDetails.isShowingDetails() then 
            showDetails.hideDetails()
            ent.nametag.value = NOT_SHOWING_TAG
        else
            showDetails.showDetails()
            ent.nametag.value = SHOWING_TAG
        end
    end,

    initXY = true,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "this ent needs to be assigned to an rgbTeam.")
        ent.nametag = {
            value = NOT_SHOWING_TAG
        }
        ent.rgbTeam = rgbTeam
    end
})


