

properties.defineProperty("maxHealth", {
    base = "baseMaxHealth",
    default = 50,

    onRecalculate = function(ent)
        ent.health = math.min(ent.health, ent.maxHealth)
        -- health can never be more than maxHealth
    end,
})

