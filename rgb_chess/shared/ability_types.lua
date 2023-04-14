
--[[

List of valid ability enums

]]

local abilityList = {

    "test"

}


local abilityTypes = {}
for _, abil in ipairs(abilityList) do
    abilityTypes[abil] = abil
end


abilityTypes = base.Enum(abilityTypes)


return abilityTypes

