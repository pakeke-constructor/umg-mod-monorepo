
local BULLET_SPEED = 400
local START_DIST = 30


if client then
    local psys = visualfx.particles.newParticleSystem({"circ3", "circ2", "circ1"})
    psys:setColors(
        {0.6,0.6,0.6},
        {0.2,0.2,0.2}
    )
    visualfx.particles.define("musket_smoke", psys)
end



return {
    maxStackSize = 1;
    image="musket";
    itemName = "musket";

    useItem = function(self, holderEnt)
        local dx,dy = holderEnt.lookX - holderEnt.x, holderEnt.lookY - holderEnt.y
        local mag = math.distance(dx,dy)
        if mag ~= 0 then
            dx = dx/mag; dy=dy/mag
        end
        local x,y = holderEnt.x + dx*START_DIST, holderEnt.y + dy*START_DIST

        if client then
            base.client.sound.playSound("boom_main1")
            visualfx.particles.emit("musket_smoke", x,y,nil,10)
        else
            if type(dx) == "number" and type(dy) == "number" then        
                local e = server.entities.player(x, y, holderEnt.controller)
                e.vx = dx*BULLET_SPEED
                e.vy = dy*BULLET_SPEED     
            end
        end
    end;
    
    itemHoldType = "recoil",
}


