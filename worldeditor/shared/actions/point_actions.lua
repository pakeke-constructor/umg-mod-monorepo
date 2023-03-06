

--[[  POINT ACTIONS  ]]


-- ABSTRACT BASE CLASS
local PointAction = base.Class("worldeditor:PointAction")



local PointSpawn = base.Class("worldeditor:PointScriptAction", PointAction)





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
    ctor(math.floor(x), math.floor(y))
end




