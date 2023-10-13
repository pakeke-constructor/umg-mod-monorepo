

local DEFAULT = "UNNAMED"

local SCALE = 1/2

local EXTRA_OY = 10

local BACKGROUND_COLOR = {0.2,0.2,0.2,0.5}


components.project("nametag", "text", function(ent)
    ent.text = {
        scale = SCALE,
        default = DEFAULT,
        component = "controller",
        oy = EXTRA_OY,
        background = BACKGROUND_COLOR,
    }
end)

