
_G.constants = {
    PROJECTILE_SPEED = 280,

    MAX_INCOME = 20,

    MAX_ACTION_DEPTH = 16,

    CARD_LIGHTNESS = 0.3,
    DEFAULT_CARD_IMAGE = "blank_card",

    DEFAULT_RARITY = 1,

    REROLL_TIME = 0.15,
    REROLL_COST = 1,

    WIN_INCOME = 10,
    LOSE_INCOME = 7,
    
    SQUADRON_COUNT_INCREMENT = 1,

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
        ABILITY = "ABILITY",
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
    }),

    UNIT_TYPES = base.Enum({
        MELEE = "MELEE",
        RANGED = "RANGED",
        SORCERER = "SORCERER" -- sorcerers can hold items
    }),

    ITEM_TYPES = base.Enum({
        PASSIVE = "PASSIVE",
        USABLE = "USABLE"
    })
}


return _G.constants
