

--[[

TODO: SUPER SUPER IMPORTANT:

There is a pretty big optimization opportunity we can make here.
We can loop over all entityTypes, and check for etypes with
projection-components.

From there, we should add targetComponents to the etype from a static
context!
This would make things a bit more efficient.

The issue, is that currently the UMG engine doesn't allow for mutating
entity-types at runtime.
Some changes will need to happen before we can do this optimization.



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




local function setupProjectionRemoval(group, targetComponent)
    group:onRemoved(function(ent)
        if not ent[targetComponent] then
            return -- wtf??? okay...? How tf did this happen?!??
        end

        local projectorGroupList = targetToProjectorGroupList[targetComponent]
        for _, pGroup in ipairs(projectorGroupList) do
            if pGroup:has(ent) then
                -- We shouldn't remove the targetComponent,
                -- since there is another group that is projecting it.
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
