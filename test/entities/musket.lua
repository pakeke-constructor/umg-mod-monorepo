
local BULLET_SPEED = 400
local START_DIST = 30


if client then
    local psys = base.particles.newParticleSystem({"circ3", "circ2", "circ1"})
    psys:setColors(
        {0.6,0.6,0.6},
        {0.2,0.2,0.2}
    )
    base.particles.define("musket_smoke", psys)
end



return {
    "x","y",
    "stackSize",
    "hidden",
    "itemBeingHeld",
    maxStackSize = 1;
    image="musket";
    itemName = "musket";

    useItem = function(self, holderEnt, dx, dy)
        if client then
            local mag = math.distance(dx,dy)
            if mag ~= 0 then
                dx = dx/mag; dy=dy/mag
            end
            local x,y = holderEnt.x + dx*START_DIST, holderEnt.y + dy*START_DIST
            base.playSound("boom_main1")
            base.particles.emit("musket_smoke", x,y,nil,10)
        else
            if type(dx) == "number" and type(dy) == "number" then        
                local e = server.entities.bullet()
                local mag = math.distance(dx,dy)
                if mag ~= 0 then
                    dx = dx/mag; dy=dy/mag
                end
                local x,y = holderEnt.x + dx*START_DIST, holderEnt.y + dy*START_DIST
                e.x = x
                e.y = y
                e.vx = dx*BULLET_SPEED
                e.vy = dy*BULLET_SPEED     
            end
        end
    end;
    
    itemHoldType = "recoil"
}

