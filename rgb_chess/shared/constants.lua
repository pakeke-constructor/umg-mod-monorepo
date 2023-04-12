
_G.constants = {
    PROJECTILE_SPEED = 280,

    MAX_INCOME = 20,

    MAX_ACTION_DEPTH = 16,

    CARD_LIGHTNESS = 0.3,
    DEFAULT_CARD_IMAGE = "blank_card",

    REROLL_TIME = 0.15,
    REROLL_COST = 1,

    WIN_INCOME = 10,
    LOSE_INCOME = 7,

    BOARD_WIDTH = 700,
    BOARD_HEIGHT = 700,
    BOARD_BORDER_LEIGHWAY = 80,

    COLOR_SUB_TAG = "%[color%]",

    PVE_PREFIX = "@pve_enemy_", -- concat this with another rgbTeam to get the category.,
    
    PROJECTILE_TYPES = base.Enum({
        DAMAGE = "DAMAGE",
        HEAL = "HEAL",
        SHIELD = "SHIELD",
        CUSTOM = "CUSTOM",
        BUFF = "BUFF",
        DEBUFF = "DEBUFF"
    }),

    BUFF_TYPES = base.Enum({
        ATTACK_DAMAGE = "ATTACK_DAMAGE",
        ATTACK_SPEED = "ATTACK_SPEED",
        SPEED = "SPEED",
        HEALTH = "HEALTH",
        SORCERY = "SORCERY"
    }),
    
    CARD_TYPES = base.Enum({
        UNIT = "UNIT",
        SPELL = "SPELL",
        ITEM = "ITEM"
    })
}


return _G.constants
