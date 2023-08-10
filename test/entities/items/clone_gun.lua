

return {
    maxStackSize = 1;
    image="clone_gun";

    itemName = "Clone gun!";
    itemDescription = "Clones whatever entity uses it";

    projectileLauncher = {
        spawnProjectile = function(itemEnt, holderEnt)
            local clone = holderEnt:deepClone()
            return clone
        end,

        speed = 100, -- speed of projectiles
        count = 1, -- num fired

        inaccuracy = 0,

        startDistance = 40,
    },

    itemCooldown = 1,
   
    itemHoldType = "recoil",
}

