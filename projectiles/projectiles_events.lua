

-- Called when a projectile is launched.
umg.defineEvent("projectiles:shoot")


-- Called when a shooter item is used:
umg.defineEvent("projectiles:useGun")
-- Note: this will only be called if the `mode` matches the projectile!


-- Called when a projectile hits a target
umg.defineEvent("projectiles:hit")

