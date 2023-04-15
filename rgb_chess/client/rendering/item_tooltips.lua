
local uiTools = require("client.rendering.ui_tools")


umg.on("displayItemTooltip", function(itemEnt)
    local itemInfo = itemEnt.itemInfo
    --[[
        PLANNING:

        ---
        item abilities
        ---
        rgb + matching
    ]]
    Slab.Separator()
    uiTools.renderRGBInfo(itemEnt.rgb)
end)

