
local uiTools = require("client.rendering.ui_tools")



local UNIT_INFO_WINDOW_X = 20
local UNIT_INFO_WINDOW_Y = 20


local function singleUnitStats(ent)
    Slab.Separator()
    uiTools.renderUnitHealth(ent.maxHealth)
   
    -- todo: Make this more robust. perhaps rgb.isAttacker(ent)?
    if ent.attackDamage and ent.attackSpeed then
        uiTools.renderUnitDamage(ent.attackDamage, ent.attackSpeed)
    end

    -- todo: Make this more robust. Perhaps rgb.isSorcerer(ent)?
    if ent.sorcery and ent.sorcery > 0 then
        uiTools.renderUnitSorcery(ent.sorcery)
    end
end



local function drawUnitInfo(ent)
    Slab.BeginWindow("unitInfoPopup", {X=UNIT_INFO_WINDOW_X, Y=UNIT_INFO_WINDOW_Y})
    
    local unitEType = ent:getClass()
    uiTools.renderBasicUnitInfo(unitEType, ent.rgb)

    for _, e in ipairs(ent.squadron) do
        singleUnitStats(e)
    end
    
    uiTools.renderRGBInfo(ent.rgb)

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


