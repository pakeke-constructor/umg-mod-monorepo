

local Terrain = require("terrain")
local terrainIds = require("terrain_ids")




local function pushQuads(quad, indexToQuads, indexToWallQuads, height)
    --[[
        TODO:
        Group wall quads together,
        and group top quads together
    ]]
    assert(quad.centerX and quad.centerY, "???")
    local i = base.client.getDrawDepth(quad.centerY, 0)
    indexToQuads[i] = indexToQuads[i] or base.Array()
    local verts = {
        {quad.a.x, quad.a.y}, {quad.b.x, quad.b.y}, 
        {quad.c.x, quad.c.y}, {quad.d.x, quad.d.y}
    }
    for _, v in ipairs(verts) do
        indexToQuads[i]:add(v)
    end

    local verts_wall = {
        {quad.c.x, quad.c.y - height}, {quad.d.x, quad.d.y - height}, 
        {quad.c.x, quad.c.y}, {quad.d.x, quad.d.y}
    }
    local iwall = base.client.getDrawDepth(quad.centerY, -height)
    indexToWallQuads[iwall] = indexToWallQuads[i] or base.Array()
    for _, v in ipairs(verts_wall) do
        indexToWallQuads[iwall]:add(v)
    end
end



local function pushGreedyQuads(gquad, indexToGreedyQuads, height)
    -- greedy quads don't need to be drawn at the bottom.
    assert(gquad.x and gquad.y, "??")
    assert(gquad.width and gquad.height)

    local verts = {
        {gquad.x, gquad.y},
        {gquad.x + gquad.width, gquad.y},
        {gquad.x + gquad.width, gquad.y + gquad.height},
        {gquad.x, gquad.y + gquad.height}
    }

    local i = base.client.getDrawDepth(gquad.y + gquad.height, height)
    indexToGreedyQuads[i] = indexToGreedyQuads[i] or base.Array()
    for _, v in ipairs(verts) do
        indexToGreedyQuads[i]:add(v)
    end
end



local function constructDrawQuads(self, indexToQuads, indexToWallQuads)
    --[[
        TODO: We need to construct upper and lower quads,
        for high terrain and the wall terrain
    ]]
    local height = self:getWallHeight()

    for _, quad in ipairs(self:getQuads()) do
        pushQuads(quad, indexToQuads, indexToWallQuads, height)
    end

    for _, gquad in ipairs(self:getGreedyQuads()) do
        pushGreedyQuads(gquad, indexToTopQuads, height)
    end
end



local function makeMesh(verts)
    local mesh = love.graphics.newMesh(verts)
    mesh:setVertexMap(1, 2, 4, 2, 3, 4)
    return mesh
end




local defaultWallTexture, defaultTopTexture

local function getDefaultTopTex()
    defaultTopTexture = defaultTopTexture or love.graphics.newImage("assets/terrain_default_top_texture.png")
    return defaultTopTexture
end


local function getDefaultWallTex()
    defaultWallTexture = defaultWallTexture or love.graphics.newImage("assets/terrain_default_wall_texture.png")
    return defaultWallTexture
end




local function constructMeshes(tobj, indexToQuads, indexToWallQuads, indexToGreedyQuads)
    local drawIndexToMesh = {}
    local drawIndexToGreedyMesh = {}

    for drawIndex, verts in pairs(indexToQuads) do
        local mesh = makeMesh(verts)
        local tex = tobj:getWallTexture() or getDefaultWallTex()
        mesh:setTexture(tex)
        drawIndexToMesh[drawIndex] = mesh
    end

    for drawIndex, gverts in pairs(indexToGreedyQuads) do
        local mesh = makeMesh(gverts)
        local tex = tobj:getTopTexture() or getDefaultTopTex()
        mesh:setTexture(tex)
        drawIndexToGreedyMesh[drawIndex] = mesh
    end

    tobj.drawIndexToMesh = drawIndexToMesh
    tobj.drawIndexToGreedyMesh = drawIndexToGreedyMesh
end






Terrain.setFinalizeCallback(function(tobj)
    local indexToQuads, indexToGreedyQuads = {}, {}
    constructDrawQuads(tobj, indexToQuads, indexToGreedyQuads)
    constructMeshes(tobj, indexToQuads, indexToGreedyQuads)
end)






umg.on("drawIndex", function(drawIndex)
    for _, terrain in ipairs(terrainIds.getTerrainObjects().objects) do
        local ditgm = terrain.drawIndexToGreedyMesh
        if ditgm and ditgm[drawIndex] then
            love.graphics.draw(ditgm[drawIndex])
        end

        local ditm = terrain.drawIndexToMesh
        if ditm and ditm[drawIndex] then
            love.graphics.draw(ditgm[drawIndex])
        end
    end
end)


