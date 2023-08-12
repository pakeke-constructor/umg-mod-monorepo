

local START_DIST = 30

return {
    maxStackSize = 1;
    image="red_player_down_1";
    itemName = "player_item";
    nametag = {
        value = "max_23"
    },
    itemHoldType = "recoil",

    useItem = function(self, holderEnt)
        local dx,dy = holderEnt.lookX - holderEnt.x, holderEnt.lookY - holderEnt.y
        local mag = math.distance(dx,dy)
        if mag ~= 0 then
            dx = dx/mag; dy=dy/mag
        end
        local x,y = holderEnt.x + dx*START_DIST, holderEnt.y + dy*START_DIST

        if client then
            sound.playSound("boom_main1")
            juice.particles.emit("musket_smoke", x,y,nil,10)
        else
            if type(dx) == "number" and type(dy) == "number" then        
                local e = server.entities.player(x,y)
                e.controller = holderEnt.controller
            end
        end
    end;

    init = base.initializers.initXY
}


