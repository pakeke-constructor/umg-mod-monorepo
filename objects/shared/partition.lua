
--[[
    
Spatial partition object, across the x,y plane


Each spatial partition object has a big map of chunks that
contain entities.
Think of each "chunk" as like a big bucket where entities are kept.


]]
local Class = require("shared.class")

local Array = require("shared.array")
local Set = require("shared.set")



local Partition = Class("objects:Partition")


function Partition:init(chunkSize)    
    -- gotta define metatable in here to capture `self` closure
    local array2dOfChunk_mt = {
        __index = function(t,x)
            t[x] = setmetatable({}, {
                __index = function(t2, y)
                    local chunk = Set()
                    t2[y] = chunk
                    self.chunkList:add(chunk)
                    return t2[y]
                end
            })
            return t[x]
        end    
    }

    self.chunks = setmetatable({}, array2dOfChunk_mt)
    self.chunkList = Array()
    self.chunkSize = chunkSize

    self.entityToLastX = {--[[
        [ent] --> lastX
    ]]}
    self.entityToLastY = {--[[
        [ent] --> lastY
    ]]}
end



function Partition:getChunkIndexes(x, y)
    return math.floor(x / self.chunkSize), math.floor(y / self.chunkSize)
end


function Partition:removeEmptyChunks()
    --[[
        TODO: this doesn't work.
        We need to also be removing from `self.chunks` too!
    ]]
    for i=#self.chunkList, 1, -1 do
        local c = self.chunkList[i]
        if c:isEmpty() then
            self.chunkList:quickPop(i)
        end
    end
end

function Partition:getLastXY(ent)
    return self.entityToLastX[ent] or ent.x, self.entityToLastY[ent] or ent.y
end

function Partition:setLastXY(ent)
    self.entityToLastX[ent] = ent.x
    self.entityToLastY[ent] = ent.y
end



--[[
    moves an entity into a different chunk if required
]]
function Partition:updateEntity(ent)
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



--[[
:addEntity and :removeEntity should be executed atomically,
i.e. between frames.

Tagging onto group's onRemoved and onAdded is what should be done in the ideal case.
]]
function Partition:addEntity(ent)
    local ix, iy = self:getChunkIndexes(ent.x, ent.y)
    self.chunks[ix][iy]:add(ent)
    self:setLastXY(ent)
end


function Partition:removeEntity(ent)
    local lastx, lasty = self:getLastXY(ent)
    local ix, iy = self:getChunkIndexes(lastx or 0, lasty or 0)
    self.chunks[ix][iy]:remove(ent)
    self.entityToLastX[ent] = nil
    self.entityToLastY[ent] = nil
end






local forEachAssert = typecheck.assert("number", "number", "function")

function Partition:forEach(x, y, func)
    forEachAssert(x,y,func)
    
    local ix, iy = self:getChunkIndexes(x, y)
    for xx = ix-1, ix+1, 1 do
        for yy = iy-1, iy+1, 1 do
            if rawget(self.chunks, xx) and rawget(self.chunks[xx], yy) then
                local chunkSet = self.chunks[xx][yy]
                for _, ent in ipairs(chunkSet) do
                    func(ent)
                end
            end
        end
    end
end






local function tryGetChunk(self,ix,iy)
    return rawget(self.chunks, ix) and rawget(self.chunks[ix], iy)
end




function Partition:contains(ent)
    local entX, entY = self:getLastXY(ent)
    local ix, iy = self:getChunkIndexes(entX, entY)
    local chunk = tryGetChunk(ix,iy)
    if chunk and chunk:has(ent) then
        return true
    end
    return false
end





local iterAssert = typecheck.assert("number", "number")

function Partition:iterator(x, y)
    iterAssert(x,y)
    local ix, iy = self:getChunkIndexes(x, y)
    local dx = -1
    local dy = -1

    local chunkI = 1
    local currentChunk = tryGetChunk(self,ix+dx, iy+dy)

    return function()
        if (not currentChunk) or chunkI > currentChunk:size() then
            currentChunk = nil
            while (not currentChunk) or chunkI > currentChunk:size() do
                -- We force search for a non-empty chunk
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

        local ent = currentChunk[chunkI]
        chunkI = chunkI + 1
        return chunkI, ent
    end
end



return Partition

