

local moneyCountGroup = umg.group("moneyCount", "text")


client.on("setMoney", function(rgbTeam, moneyCount)
    for _, ent in ipairs(moneyCountGroup)do
        if ent.rgbTeam == rgbTeam then
            ent.moneyCount = moneyCount
            ent.text = {
                value = "money: " .. tostring(moneyCount)
            }
        end
    end
end)


