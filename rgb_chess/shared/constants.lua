

_G.constants = {
    PROJECTILE_SPEED = 280,

    BUFF_TYPES = setmetatable({
        ATTACK_DAMAGE = "ATTACK_DAMAGE",
        ATTACK_SPEED = "ATTACK_SPEED",
        SPEED = "SPEED",
        HEALTH = "HEALTH"
    },{__index=error});

    MAX_BUFF_DEPTH = 10,

    CARD_LIGHTNESS = 0.5,

    REROLL_TIME = 0.25,
    REROLL_COST = 1,

    WIN_INCOME = 10,
    LOSE_INCOME = 7,

    BOARD_WIDTH = 700,
    BOARD_HEIGHT = 700,

    PVE_PREFIX = "@pve_enemy_" -- concat this with another rgbTeam to get the category.,
}


return _G.constants
