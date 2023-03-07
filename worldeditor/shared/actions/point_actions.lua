


--[[  POINT ACTIONS  ]]


-- ABSTRACT BASE CLASS
local PointAction = base.Class("worldeditor:PointAction")

PointAction.toolType = "PointAction"



local PointSpawn = base.Class("worldeditor:PointSpawnAction", PointAction)
local PointScript = base.Class("worldeditor:PointScriptAction", PointAction)

local pointActions = {
    PointSpawn = PointSpawn
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
        error("nyi.")
        self.entityAction:apply(ent)
    end
end

PointSpawn.params = {
    {param = "entityType", type = "etype"},
    {param = "pointAction", type = "PointAction", optional = true}
}


return pointActions
