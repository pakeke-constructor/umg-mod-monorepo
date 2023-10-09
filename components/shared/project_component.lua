

--[[

TODO: SUPER SUPER IMPORTANT:

There is a *HUGE* optimization opportunity we can make here.
If loop over all entityTypes, and check for etypes with components



]]





--[[
This data structure is used during component removal.
When a projecting comp is removed, 
we need to check if the target is still viable.

For example:
ent.image = "monkey"
    ent.drawable --> true
ent.shadow = {...}
    ent.drawable --> true
ent:removeComponent("image")
    ent.drawable --> should still be true!
]]
local targetToProjectorGroupList = {--[[
    Maps targetComponents to the projectors.

    [targetComponent] -> List{ group1, group2, group3, ... }
    A list of groups that are used for projection onto targetComponent.
]]}


local type = type


local function setupProjection(group, targetComponent, targetValue)
    group:onAdded(function(ent)
        if not ent[targetComponent] then
            ent[targetComponent] = targetValue
        end
    end)
end


local function hasProjector(ent, projector)
    -- `projector` is either a group, or a component name.
    if type(projector) == "string" then
        -- its a compName
        return ent[projector]
    elseif type(projector) == "table" then
        -- its a group!
        return projector:has(ent)
    end
    return false
end


local function setupProjectionRemoval(group, targetComponent)
    group:onRemoved(function(ent)
        if not ent[targetComponent] then
            return -- wtf??? okay...? How tf did this happen?!??
        end

        local projectors = targetToProjectorGroupList[targetComponent]
        for _, projector in ipairs(projectors) do
            if hasProjector(ent, projector) then
                -- no need to remove the targetComponent,
                -- since there something else projecting it.
                return
            end
        end

        -- okay, remove the targetComponent:
        ent:removeComponent(targetComponent)
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
    `components.project("image", "drawable", true)`
    
    This is basically saying:
    when an entity gets an `image` component:
        set `ent.drawable = true`
    
    We can also do groups:
    local g = umg.group("foo", "bar")
    components.project(g, "foobar")

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

    setupProjection(group, targetComponent, targetValue)
    setupProjectionRemoval(group, targetComponent)
end


return project
