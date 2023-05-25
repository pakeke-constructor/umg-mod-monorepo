

require("shared.rgb")

local triggers = require("shared.abilities.triggers")
local targets = require("shared.abilities.targets")
local filters = require("shared.abilities.filters")
local actions = require("shared.abilities.actions")

local abilities = require("shared.abilities.abilities")



local uiTools = {}



local healthTextArgs = {Color = {1,0.2,0.2}} 
local dmgTextArgs = {Color = {0.8,0.7,0.1}}
local dpsTextArgs = {Color = {0.9,0.3,0.1}} 
local sorcTextArgs = {Color = {0.1,0.3,0.9}}




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







local renderEtypeUnitInfoTc = typecheck.assert("table", "table")

function uiTools.renderBasicUnitInfo(unitEType, rgbColor)
    renderEtypeUnitInfoTc(unitEType, rgbColor)

    local cardInfo = unitEType.cardInfo
    Slab.Text("UNIT:")
    Slab.Text(cardInfo.name, {Color = rgbColor})
end



--[[

local function renderText(text)
    local f = love.graphics.getFont()
    local _, txt_table = f:getWrap(text, 600)
    for _, txt in ipairs(txt_table) do
        Slab.Text(txt, descTextArgs)
    end
end

]]



local textArgs = {Color = constants.ABILITY_UI_COLORS.REMAINING_ACTIVATIONS}

local renderAbilityTc = typecheck.assert("table")

local function renderAbility(ability)
    --[[
        renders an ability assuming an existing Slab context.
    ]]
    renderAbilityTc(ability)

    local targ = targets.getTarget(ability.target)
    local act = actions.getAction(ability.action)

    -- triggers
    triggers.drawSlabUI(ability.trigger)
    -- targets
    targ:drawSlabUI()

    -- filters
    if ability.filters then
        for _, filtName in ipairs(ability.filters)do
            local f = filters.getFilter(filtName)
            f:drawSlabUI()
        end
    end

    -- action
    act:drawSlabUI(ability.level or 1)

    -- remaining activations:
    Slab.Text("Activations:", textArgs)
    Slab.SameLine()
    Slab.Text(tostring(abilities.getRemainingActivations(ability)))
end



function uiTools.renderAbilityInfo(abilityList)
    Slab.Text("Abilities:")
    Slab.Separator()
    for _, ability in ipairs(abilityList)do
        renderAbility(ability)
        Slab.Separator()
    end    

    if #abilityList == 0 then
        Slab.Text("None!")
        return
    end
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
