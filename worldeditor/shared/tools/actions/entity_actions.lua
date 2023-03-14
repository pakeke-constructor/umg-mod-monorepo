
--[[  ENTITY ACTIONS  ]]


-- ABSTRACT BASE CLASS
local EntityAction = base.Class("worldeditor:EntityAction")

EntityAction.toolType = "EntityAction"



local EntityDelete = base.Class("worldeditor:EntityDeleteAction", EntityAction)
local EntityScript = base.Class("worldeditor:EntityScriptAction", EntityAction)
local EntityChangeComponent = base.Class("worldeditor:EntityChangeComponent", EntityAction)



local entityActions = {
    EntityDelete
}



-- ENTITY_DELETE START
function EntityDelete:init(params)
end

function EntityDelete:apply(ent)
    assert(server, "needs to be serverside")
    ent:delete()
end

EntityDelete.name = "Entity delete"
EntityDelete.description = "Deletes an entity"
EntityDelete.params = {}
-- ENTITY_DELETE END










return entityActions
