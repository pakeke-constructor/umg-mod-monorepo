
--[[

data structure for ordered drawing of entities

]]


local constants = require("client.constants")
local sort = require("libs.sort")




local ZIndexer = objects.class("rendering:ZIndexer")

function ZIndexer:init()
    -- Ordered drawing lists:
    self.sortedFrozenEnts = {} -- for ents that dont move
    self.sortedMoveEnts = {} -- for ents that move

    -- remove buffers:
    self.removeBufferMove = {}
    self.removeBufferMove = {}
end




local function pollRemoveBuffer(array, removeBuffer)
    for i=#array,1,-1 do
        local ent = array[i]
        if removeBuffer[ent] then
            table.remove(array, i)
            removeBuffer[ent] = nil
        end
    end
end



local function less(ent_a, ent_b)
    return getEntityDrawDepth(ent_a) < getEntityDrawDepth(ent_b)
end

function ZIndexer:update(dt)
    pollRemoveBuffer(self.sortedFrozenEnts, self.removeBufferFrozen)
    pollRemoveBuffer(self.sortedMoveEnts, self.removeBufferMove)

    sort.stable_sort(self.sortedMoveEnts, less)
end



function ZIndexer:draw()

end



function ZIndexer:heavyUpdate(dt)
    --[[
        computationally expensive update
    ]]

end



