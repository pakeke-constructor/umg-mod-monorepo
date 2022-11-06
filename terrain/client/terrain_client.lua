

local Terrain = require("terrain")
local terrainIds = require("terrain_ids")




local function pushQuads(quad, indexToQuads)
    assert(quad.centerX and quad.centerY, "???")
    local i = base.getDrawDepth(YYYY, ZZZZ)
    indexToQuads[i] = indexToQuads[i] or base.Array()
    indexToQuads[i]:add(quad)

    -- TODO: This should push the wall quad
    local iwall = base.getDrawDepth(YYYY2, ZZZZ2)
    indexToQuads[iwall] = indexToQuads[i] or base.Array()
    indexToQuads[iwall]:add(quad)
end


local function constructDrawQuads(self, indexToQuads, indexToGreedyQuads)
    --[[
        TODO: We need to construct upper and lower quads,
        for high terrain and the wall terrain
    ]]
    local height = self:getWallHeight()

    for _, quad in self:getQuads() do
        pushQuads(quad)
    end

    for _, gquad in self:getGreedyQuads() do
        assert(gquad.x and gquad.y, "??")
        local i = base.getDrawDepth(gquad.x, gquad.y)
        indexToGreedyQuads[i] = indexToGreedyQuads[i] or base.Array()
        indexToGreedyQuads[i]:add(gquad)
    end
end




Terrain.setFinalizeCallback(function(tobj)
    tobj.indexToQuads = {}
    tobj.indexToGreedyQuads = {}

    constructDrawQuads(tobj, tobj.indexToQuads, tobj.indexToGreedyQuads)
end)



local function tryDrawGreedy(terrain)
    -- greedy quads don't need to be drawn at the bottom.
    
end

local function tryDrawRegular(terrain)
    -- regular quads should be drawn everywhere, period

end





on("drawIndex", function(drawIndex)
    for _, terrain in ipairs(terrainIds.getTerrainObjects().objects) do
        
    end
end)


