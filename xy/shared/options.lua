

local options = {
    DEFAULT_SPEED = 100,

    SYNC_LEIGHWAY = 1.5, --[[
        players have 50% sync leighway. This essentially means that
        hacked clients can technically move-hack to go 50% faster;
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
