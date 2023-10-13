

if not client then
    return
end


-- entity drawing
-- (Passes ent as first argument)
umg.defineEvent("rendering:drawEntity")


-- drawing stuff at Z-index (passes z-index as first arg)
umg.defineEvent("rendering:drawIndex")


--[[
    Rendering world:
]]
-- Rendering ground:
umg.defineEvent("rendering:drawGround")
-- Rendering entities:
umg.defineEvent("rendering:drawEntities")
-- Rendering effects:
umg.defineEvent("rendering:drawEffects")


-- Rendering ui:
umg.defineEvent("rendering:drawUI")

