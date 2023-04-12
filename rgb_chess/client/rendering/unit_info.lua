
local renderTools = require("client.rendering.render_tools")




local healthTextArgs = {Color = {1,0.2,0.2}}
local dmgTextArgs = {Color = {0.8,0.7,0.1}}

local UNIT_INFO_WINDOW_X = 20
local UNIT_INFO_WINDOW_Y = 20



local function drawUnitInfo(unitEType, rgbColor)
    Slab.BeginWindow("cardInfoPopup", {X=UNIT_INFO_WINDOW_X, Y=UNIT_INFO_WINDOW_Y})

    Slab.Separator()

    Slab.Text("Health: " .. unitEType.defaultHealth, healthTextArgs)

    local damageEstimate = rgb.getDamageEstimate(unitEType.defaultAttackDamage, unitEType.defaultAttackSpeed)
    local damage = ("%.1f"):format(damageEstimate)
    Slab.Text("DPS:    " .. damage, dmgTextArgs)

    local color_str = rgb.getColorString(rgbColor)
    Slab.Text("RGB: ")
    Slab.SameLine()
    Slab.Text(color_str, {Color=rgbColor})

    renderTools.renderMatchingColors(rgbColor)

    Slab.EndWindow()
end






local rgbGroup = umg.group("rgb", "rgbUnit")


local entBeingHovered = nil

umg.on("slabUpdate", function()
    entBeingHovered = nil
    for _, ent in ipairs(rgbGroup) do
        if ent.rgbTeam == client.getUsername() then
            if base.client.isHovered(ent) then
                drawUnitInfo(ent)
                entBeingHovered = ent
            end
        end
    end
end)



umg.on("preDrawUI", function()
    if entBeingHovered then
        love.graphics.push("all")
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.setLineWidth(5)
       
        local x, y = base.client.camera:toCameraCoords(entBeingHovered.x, base.client.getDrawY(entBeingHovered.y, entBeingHovered.z))
        local scale = base.client.getUIScale()
        love.graphics.line(
            UNIT_INFO_WINDOW_X, UNIT_INFO_WINDOW_Y,
            x / scale, y / scale
        )
        
        local circle_size = 3 * (2 + math.sin(base.getGameTime() * 3))
        love.graphics.circle("line", x/scale, y/scale, circle_size)
        love.graphics.pop()
    end
end)



