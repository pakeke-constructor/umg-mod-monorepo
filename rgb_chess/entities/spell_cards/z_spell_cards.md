
# spell cards
This is pretty shitty.

These entities are never actually instantiated, they are just
used as config files, kinda.

The reason we have them as entity defs, is because this is how units work,
so it's best to stay consistent.

It's a bit hacky and bad, but oh well. :)



# Card example:
Here's an example of a spell card, with all components explained:

```lua


return {
    image = "16_of_hearts",

    cardInfo = {
        type = constants.CARD_TYPES.SPELL, -- spell cards are this type
        cost = 3, -- cost in money
        name = "16 of hearts", -- the card name to be displayed
        description = "Prints hi in the server console", -- card description

        difficultyLevel = 1, -- difficulty level where this card appears.
        -- higher difficulty level = more complex card.
        -- This is just to ensure that noobs don't get overwhelmed with complex cards.

        spellCast = function(self)
            -- This function is called when the card is played.
            -- (Note that this is only called on server)
            print("hi!")
            print("16 of hearts has been played")
        end
    },
}


```