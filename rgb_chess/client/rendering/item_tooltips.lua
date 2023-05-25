
local uiTools = require("client.rendering.ui_tools")


umg.on("displayItemTooltip", function(itemEnt)
    local itemInfo = itemEnt.itemInfo
    
    print(#itemEnt.abilities)


    Slab.Separator()

    if itemEnt.abilities then
        uiTools.renderAbilityInfo(itemEnt.abilities)
    end

    if itemEnt.rgb then
        Slab.Separator()
        uiTools.renderRGBInfo(itemEnt.rgb)
    end
end)

