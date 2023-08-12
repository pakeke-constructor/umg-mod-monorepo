

local options = {
    DEFAULT_SPEED = 100,

    SYNC_LEIGHWAY = 40, --[[
        players have X times sync leighway. This essentially means that
        hacked clients can technically move-hack to go X times as fast;
        (but on the positive side, legit clients won't be lagged backwards.)
    ]]

    DEFAULT_FRICTION = 6;
}



local VALID_OPTIONS = {
    DEFAULT_SPEED = true,
    SYNC_LEIGHWAY = true,
    DEFAULT_FRICTION = true;
}




function options.setOption(opt, val)
    if not VALID_OPTIONS[opt] then
        error("Invalid option: " .. opt)
    end
    options[opt] = val
end




return options
