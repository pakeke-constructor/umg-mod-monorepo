
require("shared.rgb")


local uiTools = {}




uiTools.healthColor = {1,0.2,0.2}
uiTools.attackColor = {0.8,0.7,0.1}
uiTools.dpsColor = {0.9,0.3,0.1}
uiTools.sorceryColor = {0.1,0.3,0.9}


local healthTextArgs = {Color = uiTools.healthColor} 
local dmgTextArgs = {Color = uiTools.attackColor}
local dpsTextArgs = {Color = uiTools.dpsColor} 
local sorcTextArgs = {Color = uiTools.sorceryColor}




local COLS_PER_LINE = 3 -- How many colors displayed per line

local COL_KEYS = base.Array()
do
for key, _ in pairs(rgb.COLS) do
    COL_KEYS:add(key)
end
table.sort(COL_KEYS)
end


function uiTools.renderRGBInfo(rgbColor)
    -- renders info about what this RGB value is,
    -- and gives information about what other colors match.

    local color_str = rgb.getColorString(rgbColor)
    Slab.Text("RGB: ")
    Slab.SameLine()
    Slab.Text(color_str, {Color=rgbColor})

    Slab.Separator()

    Slab.Text("Matches:")
    local count = 0
    for _, colname in ipairs(COL_KEYS) do
        local col = rgb.COLS[colname]
        if rgb.match(col, rgbColor) then
            Slab.Text(colname .. "  ", {Color = col})
            count = count + 1
            if count % COLS_PER_LINE ~= 0 then
                Slab.SameLine()
            end
        end
    end

    if count == 0 then
        Slab.Text("Nothing", {Color = base.Color.GRAY})
    end
end





local descTextArgs = {Color = {0.6,0.6,0.6}}


local renderEtypeUnitInfoTc = base.typecheck.assert("table", "table")

function uiTools.renderBasicUnitInfo(unitEType, rgbColor)
    renderEtypeUnitInfoTc(unitEType, rgbColor)

    local cardInfo = unitEType.cardInfo
    Slab.Text("UNIT:")
    Slab.Text(cardInfo.name, {Color = rgbColor})
     
    Slab.Text(" ")
    local f = love.graphics.getFont()
    local colorStr = rgb.getColorString(rgbColor)
    local description = cardInfo.description:gsub(constants.COLOR_SUB_TAG, colorStr)
    local _, txt_table = f:getWrap(description, 600)
    for _, txt in ipairs(txt_table) do
        Slab.Text(txt, descTextArgs)
    end
    Slab.Text(" ")
end




function uiTools.renderUnitHealth(health)
    Slab.Text("Health: " .. health, healthTextArgs)
end


function uiTools.renderUnitDamage(attackDamage, attackSpeed)

    local damageEstimate = rgb.getDamageEstimate(attackDamage, attackSpeed)
    local damage = ("%.1f"):format(damageEstimate)
    Slab.Text("DPS:    " .. damage, dpsTextArgs)

    Slab.Text("DMG: " .. attackDamage, dmgTextArgs)
    Slab.Text("ATK SPD: " .. attackSpeed, dmgTextArgs)
end


function uiTools.renderUnitSorcery(sorcery)
    Slab.Text("SORC: " .. sorcery, sorcTextArgs)
end



return uiTools
