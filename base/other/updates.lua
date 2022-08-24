

--[[

Emits a bunch of different updates, to allow for running code
once every 2 frames, or once every 5 frames, etc.

Also implements `onUpdate` component.

]]


local update60_ct = 60
local update30_ct = 30
local update5_ct = 5
local update2_ct = 2


local updateGroup = group("onUpdate")


on("update", function(dt)
    update2_ct = update2_ct - 1
    update5_ct = update5_ct - 1
    update30_ct = update30_ct - 1
    update60_ct = update60_ct - 1
    
    for _, ent in ipairs(updateGroup)do
        ent:onUpdate(dt)
    end

    if update2_ct <= 0 then
        call("update2")
        update2_ct = 2
    end

    if update5_ct <= 0 then
        call("update5")
        update5_ct = 5
    end

    if update30_ct <= 0 then
        call("update30")
        update30_ct = 30
    end

    if update60_ct <= 0 then
        call("update60")
        update60_ct = 60
    end

end)

