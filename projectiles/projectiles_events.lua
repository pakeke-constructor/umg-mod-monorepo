

-- Called when a projectile is launched.
umg.defineEvent("projectiles:shoot")


-- Called when a shooter item is used:
umg.defineEvent("projectiles:useShooter")
-- Note: this will only be called if the `use-mode` matches the projectile!


-- Called when a projectile hits a target
umg.defineEvent("projectiles:hit")

