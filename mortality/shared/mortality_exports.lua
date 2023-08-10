
require("mortality_events")



local mortality = {}

if server then
    -- server-side only API
    mortality.server = {}
end



local kill = require("shared.kill")
local damage = require("shared.damage")




local getRegen = require("shared.get_regen")

local getRegenerationTc = typecheck.assert("entity")
function mortality.getRegeneration(ent)
    getRegenerationTc(ent)
    return getRegen(ent)
end



if server then
-- server-side only API
mortality.server = {}

function mortality.server.kill(ent)
    -- only callable by server
    kill(ent)
end

function mortality.server.damage(ent, dmg)
    damage(ent, dmg)
end

end



umg.expose("mortality", mortality)
