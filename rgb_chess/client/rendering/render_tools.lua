

local renderTools = {}




renderTools.healthColor = {1,0.2,0.2}
renderTools.attackColor = {0.8,0.7,0.1}
renderTools.dpsColor = {0.9,0.3,0.1}
renderTools.sorceryColor = {0.1,0.3,0.9}


local healthTextArgs = {Color = renderTools.healthColor} 
local dmgTextArgs = {Color = renderTools.attackColor}
local dpsTextArgs = {Color = renderTools.dpsColor} 
local sorcTextArgs = {Color = renderTools.sorceryColor}




local COLS_PER_LINE = 3 -- How many colors displayed per line

local COL_KEYS = base.Array()
do
for key, _ in pairs(COL_KEYS) do
    COL_KEYS:add(key)
end
table.sort(COL_KEYS)
end

function renderTools.renderMatchingColors(rgbColor)
    -- renders matching colors UI inside of a Slab context
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

function renderTools.renderBasicUnitInfo(unitEType, rgbColor)
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




function renderTools.renderUnitHealth(health)
    Slab.Text("Health: " .. health, healthTextArgs)
end


function renderTools.renderUnitDamage(attackDamage, attackSpeed)

    local damageEstimate = rgb.getDamageEstimate(attackDamage, attackSpeed)
    local damage = ("%.1f"):format(damageEstimate)
    Slab.Text("DPS:    " .. damage, dpsTextArgs)

    Slab.Text("DMG: " .. attackDamage, dmgTextArgs)
    Slab.Text("ATK SPD: " .. attackSpeed, dmgTextArgs)
end


function renderTools.renderUnitSorcery(sorcery)
    Slab.Text("SORC: " .. sorcery, sorcTextArgs)
end



return renderTools
