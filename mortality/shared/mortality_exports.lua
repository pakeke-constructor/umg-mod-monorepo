

local mortality = {}

mortality.server = {}



local kill = require("shared.kill")



function mortality.server.kill(ent)
    -- have a `mortality.server` table.
    kill(ent)
end




umg.expose("mortality", mortality)
