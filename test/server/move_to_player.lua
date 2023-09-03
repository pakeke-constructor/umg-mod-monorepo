


local moveToPlayerGroup = umg.group("testMoveToPlayer", "x", "y")


local CHASE_DISTANCE = 500


umg.on("@tick", function()
    --[[
        this sucks!
        PLS dont use this code in real world.
        It doesn't work for multiplayer.
        entities will only chase the host.
    ]]
    local player = control.getPlayer()
    if (not player) or (not player.x) or (not player.y) then
        return
    end

    for _, ent in ipairs(moveToPlayerGroup) do
        local d = math.distance(ent.x-player.x, ent.y-player.y)
        if d < CHASE_DISTANCE then
            ent.moveX = player.x
            ent.moveY = player.y
        else
            ent.moveX = false
            ent.moveY = false
        end
    end
end)

