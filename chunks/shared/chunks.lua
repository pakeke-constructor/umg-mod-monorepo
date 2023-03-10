

local constants = require("shared.constants")

local CHUNK_SIZE = constants.CHUNK_SIZE



local chunks = {}




--[[
    ChunkRegistries contain chunks,
    and handle entities nicely.
]]
local ChunkRegistry = base.Class("chunks:ChunkRegistry")


function ChunkRegistry:init(chunkSize)    
    -- gotta define in here to capture `self` closure
    local array2dOfChunk_mt = {
        __index = function(t,x)
            t[x] = setmetatable({}, {
                __index = function(t2, y)
                    t2[y] = base.Set(self.chunkSize)
                    return t[y]
                end
            })
            return t[x]
        end    
    }

    self.chunks = setmetatable({}, array2dOfChunk_mt)
    self.chunkList = base.Array()
    self.chunkSize = chunkSize

    self.entityToLastX = {--[[
        [ent] --> lastX
    ]]}
    self.entityToLastY = {--[[
        [ent] --> lastY
    ]]}
end



function ChunkRegistry:getChunkIndexes(x, y, chunkSize)
    return math.floor(x / chunkSize), math.floor(y / chunkSize)
end


function ChunkRegistry:removeEmptyChunks()
    for i=#self.chunksList, 1, -1 do
        local c = self.chunksList[i]
        if c:isEmpty() then
            self.chunksList:quickPop(i)
        end
    end
end

function ChunkRegistry:getLastXY(ent)
    local x = self.entityToLastX[ent] or ent.x or 0
    local y = self.entityToLastY[ent] or ent.y or 0
    return x,y
end



--[[
    moves an entity into a different chunk if required
]]
function ChunkRegistry:updateEnt(ent)
    local entX, entY = self:getLastXY(ent)
    local ix, iy = self:getChunkIndexes(entX, entY, self.chunkSize)
    local ix2, iy2 = self:getChunkIndexes(ent.x, ent.y, self.chunkSize)
    if (ix ~= ix2) or (iy ~= iy2) then
        local chunkSet1 = self.chunks[ix][iy]
        chunkSet1:remove(ent)

        local chunkSet2 = self.chunks[ix2][iy2]
        chunkSet2:add(ent)
    end
end




function ChunkRegistry:forEach(x, y, func)
    local ix, iy = self:getChunkIndexes(x, y)

    for xx = ix-1, ix+1, 1 do
        for yy = iy-1, iy+1, 1 do
            if rawget(self.chunks, xx) and rawget(self.chunks[xx], yy) then
                local chunkSet = self.chunks[xx][yy]
                for _, ent in chunkSet:ipairs() do
                    func(ent)
                end
            end
        end
    end
end


