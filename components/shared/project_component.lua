

--[[

TODO: SUPER SUPER IMPORTANT:

There is a *HUGE* optimization opportunity we can make here.
If loop over all entityTypes, and check for etypes with components



]]

local function setupGroup(group, targetComponent, targetValue)
    group:onAdded(function(ent)
        if not ent[targetComponent] then
            ent[targetComponent] = targetValue
        end
    end)
end


local function getGroup(comp_or_group)
    if type(comp_or_group) == "string" then
        return umg.group(comp_or_group)
    elseif type(comp_or_group) == "table" then
        return comp_or_group
    end
end


--[[
    projects a component onto another component.

    For example:
    `project("image", "drawable", true)`
    
    This is basically saying:
    when an entity gets an `image` component:
        set `ent.drawable = true`
    
    We can also do groups:
    local g = umg.group("foo", "bar")
    project(g, "foobar")

]]
local projectTc = typecheck.assert("string|table", "string")
local function project(projection, targetComponent, targetValue)
    --[[
        `projection` is either a component that is being projected,
        or a group who's members will be projected.
    ]]
    projectTc(projection, targetComponent)
    targetValue = targetValue or true

    local group = getGroup(projection)
    setupGroup(group, targetComponent, targetValue)
end


return project
