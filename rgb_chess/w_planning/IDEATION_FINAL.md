

# RGB Chess:
OK: so this is getting to be quite a complex game.
Perhaps we have 2 modes:
`LEARNING` mode, and `NORMAL` mode.
`NORMAL` mode contains all the features, whereas `LEARNING` mode
does not contain items, nor any complicated cards.



### GAME LOOP:
- Shop phase:
    Roll for cards, buy units/items
    Freeze cards

- Battle phase:
    Battle enemies / other players

- Trade phase:
    Trade with other players.
    Buy auctioned items



## Reroll mechanics:
In rgb-chess, you get 1 free reroll every turn.

In order to reroll more, the player must buy cards that invoke
a reroll. See `THING_IDEAS` for some concrete ideas on this.



## Core mechanics to interact with:
These are a list of core mechanics that should interact with other
units and items.


#### In-Game Mechanics to interact with:
- Attacking, Getting Damaged
- Healing
- Buffing / Debuffing
- Shielding / Breaking of shields
- Stun
- Summoning
- Death
- Use item
- StartBattle 

#### In-Shop Mechanics to interact with:
- StartShopTurn / EndShopTurn
- Reroll
- Buy/Sell
- Equip/Unequip item
- Ally change color
- Lose / Win round
- gain Income
- Shop price change



