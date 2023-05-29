
local cardLockTc = typecheck.assert({
    x = "number",
    y = "number",
    shopIndex = "number",
    rgbTeam = "string"
})


local LOCKED_IMG = "locked"
local UNLOCKED_IMG = "unlocked"



return {
    rgbCardLock = true,

    onClick = true,
    
    LOCKED_IMG = LOCKED_IMG,
    UNLOCKED_IMG = UNLOCKED_IMG,

    init = function(e, options)
        cardLockTc(options)
        for k,v in pairs(options) do
            e[k] = v
        end
        e.isLocked = false
        e.image = UNLOCKED_IMG
    end
}
