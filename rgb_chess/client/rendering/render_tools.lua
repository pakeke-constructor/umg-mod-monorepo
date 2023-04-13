

local renderTools = {}




local COLS_PER_LINE = 3 -- How many colors displayed per line

function renderTools.renderMatchingColors(rgbColor)
    -- renders matching colors UI inside of a Slab context
    Slab.Text("Matches:")
    local count = 0
    for colname, col in pairs(rgb.COLS) do
        if rgb.match(col, rgbColor) then
            Slab.Text(colname .. "  ", {Color = col})
            count = count + 1
            if count % COLS_PER_LINE == 0 then
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

    local unitCardInfo = unitEType.unitCardInfo
    Slab.Text("UNIT:")
    Slab.Text(unitCardInfo.name, {Color = rgbColor})
     
    Slab.Text(" ")
    local f = love.graphics.getFont()
    local colorStr = rgb.getColorString(rgbColor)
    local description = unitCardInfo.description:gsub(constants.COLOR_SUB_TAG, colorStr)
    local _, txt_table = f:getWrap(description, 600)
    for _, txt in ipairs(txt_table) do
        Slab.Text(txt, descTextArgs)
    end
    Slab.Text(" ")
end


return renderTools
