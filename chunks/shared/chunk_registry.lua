
--[[
    ChunkRegistrys contain chunks,
    and handle entities nicely.

    NOTE:
    Entities must be updated MANUALLY when dealing with ChunkRegistries!
    This isn't done automatically!!!

    See `chunks.lua` for an example.

]]
local ChunkRegistry = base.Class("chunks:ChunkRegistry")


function ChunkRegistry:init(chunkSize)    
    -- gotta define in here to capture `self` closure
    local array2dOfChunk_mt = {
        __index = function(t,x)
            t[x] = setmetatable({}, {
                __index = function(t2, y)
                    local chunk = base.Set()
                    t2[y] = chunk
                    self.chunkList:add(chunk)
                    return t2[y]
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



function ChunkRegistry:getChunkIndexes(x, y)
    return math.floor(x / self.chunkSize), math.floor(y / self.chunkSize)
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
    return self.entityToLastX[ent], self.entityToLastY[ent]
end

function ChunkRegistry:setLastXY(ent)
    self.entityToLastX[ent] = ent.x
    self.entityToLastY[ent] = ent.y
end



--[[
    moves an entity into a different chunk if required
]]
function ChunkRegistry:updateEnt(ent)
    local entX, entY = self:getLastXY(ent)
    local ix, iy = self:getChunkIndexes(entX, entY)
    local ix2, iy2 = self:getChunkIndexes(ent.x, ent.y)
    if (ix ~= ix2) or (iy ~= iy2) then
        local chunkSet1 = self.chunks[ix][iy]
        chunkSet1:remove(ent)

        local chunkSet2 = self.chunks[ix2][iy2]
        chunkSet2:add(ent)

        self:setLastXY(ent)
    end
end



function ChunkRegistry:addEntity(ent)
    local ix, iy = self:getChunkIndexes(ent.x, ent.y)
    self.chunks[ix][iy]:add(ent)
    self:setLastXY(ent)
end


function ChunkRegistry:removeEntity(ent)
    local lastx, lasty = self:getLastXY()
    local ix, iy = self:getChunkIndexes(lastx or 0, lasty or 0)
    self.chunks[ix][iy]:remove(ent)
    self.entityToLastX[ent] = nil
    self.entityToLastY[ent] = nil
end



local forEachAssert = base.typecheck.assert("number", "number", "function")

function ChunkRegistry:forEach(x, y, func)
    forEachAssert(x,y,func)
    
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






local function tryGetChunk(self,ix,iy)
    return rawget(self.chunks, ix) and rawget(self.chunks[ix], iy)
end


local iterAssert = base.typecheck.assert("number", "number")

function ChunkRegistry:iterate(x, y)
    iterAssert(x,y)
    local ix, iy = self:getChunkIndexes(x, y)
    local dx = -1
    local dy = -1

    local chunkI = 1
    local currentChunk = tryGetChunk(self,ix+dx, iy+dy)

    return function()
        if (not currentChunk) or chunkI > currentChunk.size then
            currentChunk = nil
            while (not currentChunk) do
                if dx < 1 then
                    dx = dx + 1
                elseif dy < 1 then
                    dy = dy + 1
                    dx = -1
                else
                    return nil -- done iteration. Searched all chunks.
                end
                currentChunk = tryGetChunk(self,ix+dx, iy+dy)
                chunkI = 1
            end
        end

        local ent = currentChunk:get(chunkI)
        chunkI = chunkI + 1
        return chunkI, ent
    end
end



return ChunkRegistry

