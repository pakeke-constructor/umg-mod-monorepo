

# RGB Chess:
OK: so this is getting to be quite a complex game.
Perhaps we have a few modes:
`LEARNING` mode, contains simple cards only
`NORMAL` mode, contains all the features
`EXPERT` mode, super hard mode, and has extra bosses at the end.

Make sure to write JSON files of people's army when playing!
This will give good test data!!!



### GAME LOOP:
- Shop phase:
    Roll for cards, buy units/items
    Freeze cards

- Battle phase:
    Battle enemies / other players

- Trade phase:
    Trade with other players.
    Buy auctioned items


## IDEA:: Resource mechanics:
In RGB-Chess, many things are treated as resources.
Money is the most basic resource.
But besides that, we could have resources that

- rerolls are a resource / currency
- unit levels are a resource / currency
- lives (or max hp) is a resource / currency



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



