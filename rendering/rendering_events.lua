

if not client then
    return
end


-- entity drawing
-- (Passes ent as first argument)
umg.defineEvent("rendering:preDrawEntity")
umg.defineEvent("rendering:drawEntity")
umg.defineEvent("rendering:postDrawEntity")


-- drawing stuff at Z-index (passes z-index as first arg)
umg.defineEvent("rendering:drawIndex")



-- Drawing of world:
umg.defineEvent("rendering:preDrawWorld")

umg.defineEvent("rendering:drawGround")
umg.defineEvent("rendering:drawEntities")
umg.defineEvent("rendering:drawEffects")

umg.defineEvent("rendering:postDrawWorld")





-- rendering 
umg.call("rendering:preDrawUI")
umg.call("rendering:mainDrawUI")
umg.call("rendering:postDrawUI")

