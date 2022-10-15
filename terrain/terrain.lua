
local terrainIds = require("terrain_ids")


local Terrain = base.Class("terrain_mod:terrain")

--[[


algorithm idea:

=====================
Easy marching squares
=====================

Given a heightmap H,
and a grid of nodes G,
and a height threshold X,

Get the height at each node.
If the height at node is above height threshold X,
then set the node as "filled".

output 1:  quadList = array()
output 2:  greedyQuadList = array()
(for greedy mesh optimization)

For all filled nodes N:
    if N is next to an unfilled node:
        Create 4 vertices around N, in a square.
        (MAKE SURE TO SHARE THESE VERTICES!!!)
        Lerp the 4 vertices towards height threhold X.
        convert vertices into a quad, and add to `quadList`.
    else, N is only next to unfilled nodes:
        this means we can optimize using greedy mesh algorithm.
        Add N to `greedyQuadList`

Iterate over greedyQuadList,
and optimize using 2d greedy mesh algorithm


]]



local function setMap0(self)
    for x=1, self.w do
        local t = {}
        for y=1, self.h do
            t[y] = 0            
        end
        self.map[x] = t
    end
end

local function setMap(self, map)
    self.map = map
end


local DEFAULT_CUTOFF_HEIGHT = 0.5


function Terrain:init(options)
    assert(options.stepX and options.stepY, "incorrect options table")
    assert(options.sizeX and options.sizeY, "incorrect options table")

    self.cutoffHeight = options.cutoffHeight or DEFAULT_CUTOFF_HEIGHT

    self.vertexInterpolationRate = options.vertexInterpolationRate
    if self.vertexInterpolationRate and self.vertexInterpolationRate > 0.5 then
        error("vertexInterpolationRate shouldn't be higher than 0.5; a good value is between 0 and 0.3")
    end

    self.syncOptions = options
    -- We need to keep this table as a reference if we want to sync
    -- from clientside -> serverside

    self.stepX = options.stepX
    self.stepY = options.stepY
    self.sizeX = options.sizeX
    self.sizeY = options.sizeY

    self.w = math.ceil(self.sizeX / self.stepX)
    self.h = math.ceil(self.sizeY / self.stepY)

    self.worldX = options.x or 0
    self.worldY = options.y or 0

    if server then
        terrainIds.setTerrainId(self, terrainIds.generateId())
    end

    self.map = {}
    setMap0(self)
end





function Terrain:clear()
    setMap0(self)
end


function Terrain:setWorldPosition(x,y)
    self.syncOptions.x = x
    self.syncOptions.y = y
    self.worldX = x
    self.worldY = y
    -- TODO: Update the physics objects and the quads here!!!
    error("not yet implemented")
end


function Terrain:getWorldPosition()
    assert(self.worldX and self.worldY, "terrain not given world position!")
    return self.worldX, self.worldY
end


local function toWorldCoords(self, ix, iy)
    -- converts indexes in the .map structure to world coords
    local x,y = self:getWorldPosition()
    x = x + (ix-1) * self.stepX
    y = y + (iy-1) * self.stepY
    return x,y
end


local function toMapXY(self, worldX, worldY)
    -- converts world XY position to indexes in the .map structure.
    local wx, wy = self:getWorldPosition()
    local x,y = worldX - wx, worldY - wy
    x = math.floor(x / self.stepX + 0.5) + 1
    y = math.floor(y / self.stepY + 0.5) + 1
    if x > self.w or x < 1 or y > self.h or y < 1 then
        return nil
    else
        return x,y
    end
end




local LERP_ITERATIONS = 4
local DEFAULT_LERP_DELTA = 0.3

local TERRAIN_LERP_EPSILON = 0.015 -- ngl this is pretty arbitrary, i dont think it matters too much

local abs = math.abs

local DEFAULT_LERP_EPSILON = 0.0001


local function lerpTowardsTarget(target, epsilon, delta, a,b,c,d)
    --[[
        Given height values for corners (a,b,c,d),
        return a good guess for a position (x,y)
        where the height is equal to target.

        Returns (X,Y) position in normalized space,
        i.e. X and Y are both between 0 and 1.

        a-- AB --b
        |        |
       AD   OO   BC
        |        |
        d-- CD --c
    ]]
    local x = 0.5
    local y = 0.5

    delta = delta or DEFAULT_LERP_DELTA
    epsilon = epsilon or DEFAULT_LERP_EPSILON

    for _=1, LERP_ITERATIONS do
        local ab = (a*(1-x) + b*x)
        local cd = (d*(1-x) + c*x)
    
        local ad = (a*(1-y)+d*y)
        local bc = (b*(1-y)+c*y)
    
        -- prediction of the heights at positions (x,y)
        local height_heur_x = (ad*(1-x)+bc*x)
        local height_heur_y = (ab*(1-y)+cd*y)

        local dx,dy
        local dxheur = target - height_heur_x
        local dyheur = target - height_heur_y
        local dist = dxheur*dxheur + dyheur*dyheur
        dist = math.sqrt(dist)

        if abs(dxheur) < epsilon or abs(bc-ad) == 0 then
            dx = 0
        else
            local upX = (bc-ad) / abs(bc-ad)
            local signedHeurDx = dxheur / dist
            dx = delta * upX * signedHeurDx 
        end

        if abs(dyheur) < epsilon or abs(cd-ab) == 0 then
            dy = 0
        else
            local upY = (cd - ab) / abs(cd - ab)
            local signedHeurDy = dyheur / dist
            dy = delta * upY * signedHeurDy
        end

        x = x + dx
        y = y + dy
        delta = delta / 2
    end

    return x, y
end





local function getHeight(self, x, y)
    local map = self.map
    if x < 1 or x > self.w or y < 1 or y > self.h then
        return 0 -- default height
    end
    return map[x][y] or 0
end


local function isNextToUnfilled(self, x, y)
    local cutoffHeight = self.cutoffHeight
    for xi=-1, 1 do
        for yi=-1, 1 do
            if xi~=0 and yi~=0 then
                local h = getHeight(self, x+xi, y+yi)
                if h < cutoffHeight then
                    return true
                end
            end
        end
    end
    return false
end


local function getVertexCornerHeightsABCD(self, x, y)
    local a = getHeight(self, x, y)
    local b = getHeight(self, x+1, y)
    local c = getHeight(self, x+1, y+1)
    local d = getHeight(self, x, y+1)
    return a,b,c,d
end



local rawget = rawget

local function mapPosFilled(map, x, y)
    return rawget(map, x) and map[x][y]
end

local function trySnapOntoGreedyMesh(self, x, y, greedyQuadMap)
    --[[
        (x,y) are indexes on self.map  (and/or)  greedyQuadMap.
        ------------------

        Snaps a vertex onto the greedy mesh if possible.

        CASES:  (V = vertex, G = greedy-meshed-vert )

        CASE A:
        X   .
          V    snap left <---   (same for right)
        X   .

        CASE B:
        X   X
          V    snap up ^^^  (same for down)
        .   . 

        CASE C:
        .   .
          V    snap bottom left  (same for all symmetries)
        X   .

        CASE D:
        .   .
          V    snap bottom left  (same for all symmetries)
        X   .
    ]]
    local cx,cy = toWorldCoords(self, x, y)

    local dx, dy = self.stepX/2, self.stepY/2
    local m = greedyQuadMap

    -- case C,D bot-left
    if (mapPosFilled(m, x-1, y) and mapPosFilled(m, x, y+1)) or mapPosFilled(m,x-1,y+1) then
        return cx-dx, cy+dy
    -- case C,D top-left
    elseif (mapPosFilled(m, x-1, y) and mapPosFilled(m, x, y-1)) or mapPosFilled(m,x-1,y-1) then
        return cx-dx, cy-dy
    -- case C,D bot-right
    elseif (mapPosFilled(m, x+1, y) and mapPosFilled(m, x, y+1)) or mapPosFilled(m,x+1,y+1) then
        return cx+dx, cy+dy
    -- case C,D top-right
    elseif (mapPosFilled(m, x+1, y) and mapPosFilled(m, x, y-1)) or mapPosFilled(m,x+1,y-1) then
        return cx+dx, cy-dy
    
    -- cases A and B:
    -- snap to top
    elseif mapPosFilled(m, x+1, y-1) and mapPosFilled(m, x-1, y-1) then
        return cx, cy-dy
    -- snap to bottom
    elseif mapPosFilled(m, x+1, y+1) and mapPosFilled(m, x-1, y+1) then
        return cx, cy+dy
    -- snap to right
    elseif mapPosFilled(m, x+1, y-1) and mapPosFilled(m, x+1, y+1) then
        return cx+dx, cy
    -- snap to left
    elseif mapPosFilled(m, x-1, y-1) and mapPosFilled(m, x-1, y+1) then
        return cx-dx, cy
    end
end



local function genVertexPos(self, x, y, greedyQuadMap, corner)
    --[[
        Generates a vertex,
        where (x, y) are indexes on the self.map[x][y].

        a-- AB --b
        |        |
       AD   @@   BC
        |        |
        d-- CD --c

        This function will always generate the TOP LEFT vertex.
        (i.e. vertex `a`.
    ]]
    local center
    if corner == 
    local snap_x, snap_y = trySnapOntoGreedyMesh(self, x,y, greedyQuadMap)
    if false and snap_x and snap_y then
        return {
            x = snap_x,
            y = snap_y
        }
    end

    local delta = self.vertexInterpolationRate
    local cutoffHeight = self.cutoffHeight
    local a,b,c,d = getVertexCornerHeightsABCD(self, x-1, y-1)
    local vertx, verty = lerpTowardsTarget(cutoffHeight, TERRAIN_LERP_EPSILON, delta, a,b,c,d)
    
    local wx, wy = toWorldCoords(self, x-0.5, y-0.5)
    -- Okay::: this is a bit hacky. toWorldCoords is supposed to take a indexes
    -- in `self.map`, but the vertex map is offset by 0.5 units.
    -- since we are acting on the top left vertex, minusing 0.5 from the position
    -- will give the correct results here, even though it's super hacky.
    
    vertx = (vertx - 0.5) * self.stepX
    verty = (verty - 0.5) * self.stepY
    return {
        x = wx+vertx, 
        y = wy+verty
    }
end


local array2d_mt = {
    __index = function(t,k)
        t[k] = {} 
        return t[k] 
    end
}


local function greedyMeshExpandY(greedyQuadMap, x, endx, y)
    local expanding = true
    local height = 1
    while expanding do
        for xx=x, endx do
            if not(rawget(greedyQuadMap,xx) and greedyQuadMap[xx][y+height]) then
                expanding = false
            end
        end
        if expanding then
            for x2=x, endx do
                greedyQuadMap[x2][y+height] = false -- ensure these quads don't get greedy meshed multiple times
            end
            height = height + 1
        end
    end
    return height
end


local function greedyMesh(self, greedyQuadMap)
    --[[
        greedyQuadMap is a 2d array of booleans;
        true if the quad is surrounded by terrain.
    ]]
    local greedyQuadList = {}
    
    for x=1, self.w do
        for y=1, self.h do
            if rawget(greedyQuadMap,x) and greedyQuadMap[x][y] then
                -- generate a greedy mesh
                local width = 1
                greedyQuadMap[x][y] = false

                while rawget(greedyQuadMap,x+width) and greedyQuadMap[x+width][y] do
                    greedyQuadMap[x+width][y] = false -- ensure this quad doesn't get greedy meshed multiple times
                    width = width + 1
                end

                local endx = x + width - 1 -- minus 1, because if the width is 1, we want  x == endx.
                local height = greedyMeshExpandY(greedyQuadMap, x, endx, y)

                local wx, wy = toWorldCoords(self, x-0.5, y-0.5)
                width, height = width * self.stepX, height * self.stepY
                table.insert(greedyQuadList, {
                    x = wx, y = wy,
                    width = width, height = height
                })
            end
        end
    end

    return greedyQuadList
end


local function generateQuads(self)
    --[[
        Generates heightmap.

        assumes that the heightmap exists.
    ]]
    local quads = {}
    local greedyQuadMap = setmetatable({}, array2d_mt)
    local vertexMap = setmetatable({}, array2d_mt)

    local cuttoffHeight = self.cutoffHeight

    -- discover greedy mesh nodes:
    for x=1, self.w do
        for y=1, self.h do
            local height = getHeight(self, x,y)
            if height > cuttoffHeight and (not isNextToUnfilled(self, x,y)) then
                -- we flag this node to be greedy-meshed.
                -- The reason we do multiple passes with our for-loops is so
                -- the data from greedyQuadMap is fully available for genVertexPos.
                greedyQuadMap[x][y] = true
            end
        end
    end

    -- Now generate outer mesh:
    for x=1, self.w do
        for y=1, self.h do
            local height = getHeight(self, x,y)
            if height > cuttoffHeight and (not (rawget(greedyQuadMap, x) and greedyQuadMap[x][y])) then
                -- Then we generate vertices for this node
                local vertA = vertexMap[x][y] or genVertexPos(self, x, y, greedyQuadMap, "a")
                local vertB = vertexMap[x+1][y] or genVertexPos(self, x+1, y, greedyQuadMap, "b")
                local vertC = vertexMap[x+1][y+1] or genVertexPos(self, x+1, y+1, greedyQuadMap, "c")
                local vertD = vertexMap[x][y+1] or genVertexPos(self, x, y+1, greedyQuadMap, "d")
                vertexMap[x][y] = vertA
                vertexMap[x+1][y] = vertB
                vertexMap[x+1][y+1] = vertC
                vertexMap[x][y+1] = vertD
                local cx,cy = toWorldCoords(self, x,y)
                table.insert(quads, {
                    centerX = cx,
                    centerY = cy,
                    a=vertA,
                    b=vertB,
                    c=vertC,
                    d=vertD
                })
            end
        end
    end

    return quads, greedyQuadMap, vertexMap
end



local function newPhysicsRectangle(x,y,w,h)
    --[[
        (x,y) is top left.
        w,h is width and height of the block.
    ]]
    local world = base.physics.getWorld()
    local body = physics.newBody(world,x+w/2,y+h/2,"static")
    local shape = physics.newRectangleShape(w,h)
    local fixture = physics.newFixture(body,shape)
    return fixture
end


local function newPhysicsPolygon(cX, cY, a,b,c,d)
    -- cX and cY are centerX and centerY
    local world = base.physics.getWorld()
    local body = physics.newBody(world, cX, cY, "static") 
    do return end
    local shape = physics.newPolygonShape(
        a.x-cX, a.y-cY, 
        b.x-cX, b.y-cY, 
        c.x-cX, c.y-cY, 
        d.x-cX, d.y-cY
    )
    local fixture = physics.newFixture(body,shape)
    return fixture
end


local function generatePhysics(self, quads, greedyQuads)
    local fixtures = {}

    for _, quad in ipairs(quads) do
        local centerX, centerY = quad.centerX, quad.centerY
        local fixture = newPhysicsPolygon(
            centerX, centerY, 
            quad.a,quad.b,quad.c,quad.d
        )
        table.insert(fixtures, fixture)
    end

    for _, gquad in ipairs(greedyQuads) do
        local fixture = newPhysicsRectangle(
            gquad.x, gquad.y, gquad.width, gquad.height
        )
        table.insert(fixtures, fixture)
    end

    return fixtures
end



if client then
function Terrain:draw()
    assert(self.quads and self.greedyQuads, "terrain not initialized")
    graphics.push("all")
    graphics.setColor(1,0.5,0.5,0.4)
    for _,quad in ipairs(self.quads) do
        local a,b,c,d = quad.a,quad.b,quad.c,quad.d
        graphics.setColor(1,0.5,0.5,0.4)
        graphics.polygon(
            "fill",
            a.x,a.y,
            b.x,b.y,
            c.x,c.y,
            d.x,d.y
        )
        graphics.setColor(1,0,0)
        graphics.polygon(
            "line",
            a.x,a.y,
            b.x,b.y,
            c.x,c.y,
            d.x,d.y
        )
    end
    for _, rect in ipairs(self.greedyQuads) do
        graphics.setColor(0.5,0.5,1,0.4)
        graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
        graphics.setColor(0,0,1)
        graphics.rectangle("line", rect.x, rect.y, rect.width, rect.height)
    end
    for x=1, self.w do for y=1, self.h do 
        local wx,wy = toWorldCoords(self,x,y)
        graphics.setColor(1,1,1) graphics.circle("line",wx,wy,10)
    end end
    graphics.pop()
end
end




--[[
    generates physics colliders and triangle meshes
]]

if server then

function Terrain:sync()
    -- pass by id across the network
    server.broadcast("terrainSync", terrainIds.getId(self), self.syncOptions, self.map)

    local quads, greedyQuadMap, vertexMap = generateQuads(self)
    local greedyQuads = greedyMesh(self, greedyQuadMap)
    
    self.fixtures = generatePhysics(self, quads, greedyQuads)
end

else --============================================
assert(client, "client table was deleted...?")

function Terrain:sync()
    error("terrain:sync() can only be called on server-side")
end

function finalize(self)
    local quads, greedyQuadMap, vertexMap = generateQuads(self)
    local greedyQuads = greedyMesh(self, greedyQuadMap)

    self.fixtures = generatePhysics(self, quads, greedyQuads)
    self.quads = quads -- used for rendering.
    self.greedyQuads = greedyQuads
end


client.on("terrainSync", function(tobj_id, syncOptions, map)
    -- pass by id across the network
    local tobj = terrainIds.getTerrainObject(tobj_id)
    if not tobj then
        tobj = Terrain(syncOptions)
        terrainIds.setTerrainId(tobj, tobj_id)
    end
    setMap(tobj, map)
    finalize(tobj)
end)

end


function Terrain:generateFromHeightFunction(func)
    for x=1, self.w do
        for y=1, self.h do
            local wx, wy = toWorldCoords(self, x,y)
            local height = func(wx,wy)
            if not (type(height) == "number" and height>0) then
                error("Invalid height value: " .. tostring(height))
            end
            self.map[x][y] = height
        end
    end
end


return Terrain

