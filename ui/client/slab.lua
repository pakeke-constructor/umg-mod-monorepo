

local Slab = require("Slab.Slab")

Slab.Initialize()



-- We violate the export naming conventions here, because Slab itself violates the
-- naming conventions anyway.
-- It's better to stay consistent to the Slab examples :)
export("Slab", Slab)



local docks = {
    "Left", "Bottom", "Right"
}


on("update", function(dt)
    Slab.Update(dt)

    Slab.DisableDocks(docks)
    call("slabUpdate")
end)



on("draw", function(dt)
    Slab.Draw()
end)



