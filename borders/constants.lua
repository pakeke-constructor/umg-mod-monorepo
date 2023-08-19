
--[[
    TODO: These aren't implemented or used yet!
]]


local BORDER_STYLES = objects.Enum({
    "STRIPED", -- stripes, like minecraft border
    "PLAIN", -- just a flat color
    "INVISIBLE" -- border is invisible!
})



return {
    -- Available border styles:
    -- This only affects the visual aspect, doesn't affect anything functionally.
    BORDER_STYLES = BORDER_STYLES,

    DEFAULT_BORDER_STYLE = BORDER_STYLES.STRIPED
}
