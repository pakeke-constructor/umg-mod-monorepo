
--[[
    auto syncing of abilities.

    For efficiency, we only sync every X frames.
]]


if server then


local abilityGroup = umg.group("rgbUnit", "abilities")


-- run this code every 6 ticks
base.runEvery(6, "@tick", function()
    for _, ent in ipairs(abilityGroup) do
        sync.syncComponent(ent, "abilities")
    end
end)


end
