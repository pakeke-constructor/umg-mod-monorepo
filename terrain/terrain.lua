

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

For all filled nodes N:
    if N is next to an unfilled node:
        Create 4 vertices around N, in a square.
        (MAKE SURE TO SHARE THESE VERTICES!!!)
        Lerp the 4 vertices towards height threhold X.



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
    assert(exists(options.ownerEntity), "terrain needs an owner entity")

    self.ownerEntity = options.ownerEntity

    self.cutoffHeight = options.cutoffHeight or DEFAULT_CUTOFF_HEIGHT

    self.stepX = options.stepX
    self.stepY = options.stepY
    self.sizeX = options.sizeX
    self.sizeY = options.sizeY
    self.worldX = options.worldX or 0
    self.worldY = options.worldY or 0

    self.w = math.ceil(self.sizeX / self.stepX)
    self.h = math.ceil(self.sizeY / self.stepY)

    self.map = {}
    setMap0(self)
end



function Terrain:clear()
    setMap0(self)
end


function Terrain:setWorldPosition(x,y)
    self.worldX = x
    self.worldY = y
end


local function toWorldCoords(self, ix, iy)
    -- converts indexes in the .map structure to world coords
    local x,y = self.worldX, self.worldY
    x = x + (ix-1) * self.stepX
    y = y + (iy-1) * self.stepY
    return x,y
end


local function toMapXY(self, worldX, worldY)
    -- converts world XY position to indexes in the .map structure.
    local x,y = worldX - self.worldX, worldY - self.worldY
    x = math.floor(x / self.stepX + 0.5) + 1
    y = math.floor(y / self.stepY + 0.5) + 1
    if x > self.w or x < 1 or y > self.h or y < 1 then
        return nil
    else
        return x,y
    end
end


local function getCase(a,b,c,d)
    --[[
        a,b,c,d are all ether 0 or 1
    ]]
    return a*8 + b*4 + c*2 + d
end


local function lerp(A,B,targ)
    --[[
        returns a value from 0->1,
        representing how far along the line A -----> B targ is.
    ]]
    assert(A<B)
    return (targ - A) / (B-A)
end





local LERP_ITERATIONS = 4
local START_DELTA = 0.3

local TERRAIN_LERP_EPSILON = 0.015 -- ngl this is pretty arbitrary, i dont think it matters too much

local abs = math.abs

local DEFAULT_LERP_EPSILON = 0.0001


local function lerpTowardsTarget(target, epsilon, a,b,c,d)
    --[[
        Given height values for corners (a,b,c,d),
        return a good guess for a position (x,y)
        where the height is equal to target.

        a-- AB --b
        |        |
       AD   OO   BC
        |        |
        d-- CD --c
    ]]
    local x = 0.5
    local y = 0.5

    local delta = START_DELTA

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

        print(dxheur, dyheur)

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
end




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

For all filled nodes N:
    if N is next to an unfilled node:
        Create 4 vertices around N, in a square.
        (MAKE SURE TO SHARE THESE VERTICES!!!)
        Lerp the 4 vertices towards height threhold X.

]]

local function getHeight(self, x, y)
    local map = self.map
    if x < 1 or x > self.w or y < 1 or y > self.h then
        return 0 -- default height
    end
    return map[x][y]
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


local function generateVertex(self, x, y)
    --[[
        a-- AB --b
        |        |
       AD   @@   BC
        |        |
        d-- CD --c

        This function will always generate the TOP LEFT vertex.
        (i.e. the vertex at (0,0))

        So for example, in the diagram above,
        if `@@` is at (x, y), this function will generate vertex `a`.
    ]]

    local cutoffHeight = self.cutoffHeight
    local a,b,c,d = getVertexCornerHeightsABCD(self, x-1, y-1)
    local height = lerpTowardsTarget(cutoffHeight, TERRAIN_LERP_EPSILON, a,b,c,d)
    --[[ TODO:
        How do we represent the vertex here?
        Maybe we need a 2d map specifically for quad vertices.
        That way, we can discover duplicates easily too.
    ]]--
end



local function generateQuads(self)
    --[[
        assumes that the heightmap exists.
    ]]
    local quads = {}
    local cuttoffHeight = self.cutoffHeight
    for x=1, self.w do
        for y=1, self.h do
            local height = getHeight(x,y)
            if height > cuttoffHeight then
                if isNextToUnfilled(self, x,y) then
                    -- Then we generate vertices for this node
                    
                else
                    -- else, we flag this node to be greedy-meshed.

                end
            end
        end
    end
end




--[[
    generates physics colliders and triangle meshes
]]
local finalize
if server then

function finalize(self)
    server.broadcast("terrainFinalize", self.ownerEntity, self.map)
end

else

function finalize(self)

end
client.on("terrainFinalize", function(ent, map)
    local tobj = ent.terrain
    assert(tobj.ownerEntity == tobj, "??? Bad event received from server")
    tobj:setMap(map)
    finalize(tobj)
end)
end


function Terrain:generateFromHeightFunction(func)
    for x=1, self.w do
        for y=1, self.h do
            local wx, wy = toWorldCoords(x,y)
            self.map[x][y] = func(wx,wy)
        end
    end
end






