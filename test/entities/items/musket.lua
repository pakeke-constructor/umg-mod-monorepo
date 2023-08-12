

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

    projectileLauncher = {
        projectileType = "bullet",

        speed = 400, -- speed of projectiles
        count = 5, -- num fired

        inaccuracy = 0.1,

        startDistance = 20,
    },

    itemCooldown = 1,
   
    itemHoldType = "recoil",
}

