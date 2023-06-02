
local cardLockTc = typecheck.assert({
    x = "number",
    y = "number",
    shopIndex = "number",
    rgbTeam = "string"
})


local LOCKED_IMG = "card_locked"
local UNLOCKED_IMG = "card_unlocked"



return {
    rgbCardLock = true,

    onClick = true,
    
    LOCKED_IMG = LOCKED_IMG,
    UNLOCKED_IMG = UNLOCKED_IMG,

    scale = 3,

    init = function(e, options)
        cardLockTc(options)
        for k,v in pairs(options) do
            e[k] = v
        end
        e.isLocked = false
        e.image = UNLOCKED_IMG
    end
}
