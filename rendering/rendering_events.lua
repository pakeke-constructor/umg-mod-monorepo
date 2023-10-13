

if not client then
    return
end


-- entity drawing
-- (Passes ent as first argument)
umg.defineEvent("rendering:drawEntity")


-- drawing stuff at Z-index (passes z-index as first arg)
umg.defineEvent("rendering:drawIndex")



-- Rendering world:
umg.defineEvent("rendering:drawWorld")

--[[

-- TODO: remove these.
-- Make sure they are all replaced with the appropriate stuff!
umg.defineEvent("rendering:drawGround")
umg.defineEvent("rendering:drawEntities")
umg.defineEvent("rendering:drawEffects")

]]


-- Rendering ui:
umg.defineEvent("rendering:drawUI")

