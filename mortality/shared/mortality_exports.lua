

local mortality = {}

-- server-side only API
mortality.server = {}



local kill = require("shared.kill")




local getRegen = require("shared.get_regen")

local getRegenerationTc = typecheck.assert("entity")
function mortality.getRegeneration(ent)
    getRegenerationTc(ent)
    return getRegen(ent)
end


function mortality.server.kill(ent)
    -- have a `mortality.server` table.
    kill(ent)
end



umg.expose("mortality", mortality)
