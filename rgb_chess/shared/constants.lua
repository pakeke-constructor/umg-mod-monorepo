
_G.constants = {
    PROJECTILE_SPEED = 280,

    MAX_INCOME = 20,
    MAX_BUFF_DEPTH = 10,

    CARD_LIGHTNESS = 0.5,

    REROLL_TIME = 0.15,
    REROLL_COST = 1,

    WIN_INCOME = 10,
    LOSE_INCOME = 7,

    BOARD_WIDTH = 700,
    BOARD_HEIGHT = 700,

    COLOR_SUB_TAG = "%[color%]",

    PVE_PREFIX = "@pve_enemy_", -- concat this with another rgbTeam to get the category.,
    
    PROJECTILE_TYPES = base.Enum({
        DAMAGE = "DAMAGE",
        HEAL = "HEAL",
        SHIELD = "SHIELD",
        CUSTOM = "CUSTOM",
        BUFF = "BUFF"
    }),

    BUFF_TYPES = base.Enum({
        ATTACK_DAMAGE = "ATTACK_DAMAGE",
        ATTACK_SPEED = "ATTACK_SPEED",
        SPEED = "SPEED",
        HEALTH = "HEALTH"
    })
}


return _G.constants
