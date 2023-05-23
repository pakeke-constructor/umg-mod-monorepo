

require("shared.rgb")

local triggers = require("shared.abilities.triggers")
local targets = require("shared.abilities.targets")
local filters = require("shared.abilities.filters")
local actions = require("shared.abilities.actions")




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



local renderAbilityTc = typecheck.assert("table")
local function renderAbility(ability)
    --[[
        renders an ability assuming an existing Slab context.
    ]]
    renderAbilityTc(ability)

    local targ = targets.getTarget(ability.target)
    local filt = ability.filter and filters.getFilter(ability.filter)
    local act = actions.getAction(ability.action)

    --[[
        TODO: this is TERRIBLE.
        typecheckng should be done in abilities.lua.
        Also, the `abilities` component needs to be a Regular component, not shared.
        We should make a new component, `defaultAbilities` to account for this.
    ]]
    if not targ then
        error("bad target: " .. ability.target)
    end
    if not act then
        error("bad action: " .. ability.action)
    end

    -- now draw the slab ui:
    triggers.drawSlabUI(ability.trigger)
    targ:drawSlabUI()
    if filt then filt:drawSlabUI() end
    act:drawSlabUI(ability.level or 1)
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
