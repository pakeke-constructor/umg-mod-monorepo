


return {
    "x","y", 
    "moneyCount", 
    "rgbTeam",
    "text",
    image = "nothing",

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "pass in this pls")
        ent.text = {
            value = ent.moneyCount,
            overlay = true
        }
        ent.x = x
        ent.y = y
        ent.rgbTeam = rgbTeam
        ent.moneyCount = 0
    end
}

