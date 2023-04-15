
local uiTools = require("client.rendering.ui_tools")


umg.on("displayItemTooltip", function(itemEnt)
    local itemInfo = itemEnt.itemInfo

    -- TODO:
    -- render item abilities here.

    if itemEnt.rgb then
        Slab.Separator()
        uiTools.renderRGBInfo(itemEnt.rgb)
    end
end)

