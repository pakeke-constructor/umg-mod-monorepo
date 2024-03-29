


--[[  POINT ACTIONS  ]]


-- ABSTRACT BASE CLASS
local PointAction = objects.Class("worldeditor:PointAction")

PointAction.toolType = "PointAction"



local PointSpawn = objects.Class("worldeditor:PointSpawnAction", PointAction)
local PointScript = objects.Class("worldeditor:PointScriptAction", PointAction)

local pointActions = {
    PointSpawn
}


function PointSpawn:init(params)
    assert(params.entityType, "needs entityType")
    self.entityType = params.entityType
    self.entityAction = params.entityAction
end

function PointSpawn:apply(x, y)
    assert(server, "needs to be serverside")
    local ctor = server.entities[self.entityType]
    if not ctor then
        print("[worldeditor] tried to spawn invalid entityType: " .. self.entityType)
    end
    
    local ent = ctor(x, y)
    if self.entityAction then
        self.entityAction:apply(ent)
    end
end

PointSpawn.name = "Point spawn"
PointSpawn.description = "Spawns an entity at point (x,y)"
PointSpawn.params = {
    {param = "entityType", type = "etype"},

    -- TODO: Actually handle EntityActions properly
    {param = "entityAction", type = "PointAction", optional = true}
}


return pointActions
