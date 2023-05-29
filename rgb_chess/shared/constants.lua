
_G.constants = {
    PROJECTILE_SPEED = 280,

    MAX_INCOME = 20,

    MAX_BUFFERED_ABILITIES = 1600, -- how many abilities can be happening simultaneously.
    ABILITY_BUFFER_TIME = 0.4, -- wait 0.4 seconds before we apply an ability action
    MAX_ABILITY_ACTIVATIONS = 100, -- default maximum of X activations per turn, for each ability

    CARD_LIGHTNESS = 0.3,
    DEFAULT_CARD_IMAGE = "blank_card",

    MIN_DIFFICULTY_LEVEL = 0, -- cards are given a 'difficulty level' to tell how complex they are.
    MAX_DIFFICULTY_LEVEL = 4, -- This allows us to have a "learning mode."

    DEFAULT_RARITY = 1,

    DEFAULT_UNIT_LEVEL = 1,

    END_TURN_DELAY = 5, -- countdown X seconds before ending turn
    END_BATTLE_DELAY = 3, -- countdown X seconds before ending turn
    MINIMUM_BATTLE_DURATION = 5,

    REROLL_TIME = 0.15,
    REROLL_COST = 1,

    WIN_INCOME = 10,
    LOSE_INCOME = 7,
    
    SQUADRON_COUNT_INCREMENT = 10000,

    BOARD_WIDTH = 700,
    BOARD_HEIGHT = 700,
    BOARD_BORDER_LEIGHWAY = 80,

    CARD_LOCK_Y_SPACING = 70,

    UNIT_SYMBOL_ALPHA = 0.8,

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
        POWER = "POWER",
        ATTACK_SPEED = "ATTACK_SPEED",
        SPEED = "SPEED",
        HEALTH = "HEALTH"
    }),
    
    CARD_TYPES = base.Enum({
        UNIT = "UNIT",
        SPELL = "SPELL"
    }),

    UNIT_TYPES = base.Enum({
        MELEE = "MELEE",
        RANGED = "RANGED",
        SORCERER = "SORCERER" -- sorcerers can hold items
    }),

    ITEM_TYPES = base.Enum({
        PASSIVE = "PASSIVE",
        USABLE = "USABLE"
    }),

    ABILITY_UI_COLORS = {
        ACTION = {0.9,0.4,0.2},
        TRIGGER = {0.3,0.9,0.1},
        FILTER = {0.9,0.9,0.3},
        TARGET = {0.3,0.6,0.9},
        REMAINING_ACTIVATIONS = {0.9,0.8,0.7}
    }
}


return _G.constants
