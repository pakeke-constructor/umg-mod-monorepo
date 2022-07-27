
# Chests and crafting mod.

this mod handles all crafting and chest interfaces, by 
building on top of the inventory mod.

Chests are different from inventories, in that they have have an opening sound,
and a closing sound.
Also, they can be clicked on to open/close.
If the player moves too far away from the chest, then it is automatically closed.


In the future, this will also include stuff like item pipes,
automatic crafters, etc.



### PLANNING::::
```lua

return {
    "inventory";

    openable = {
        distance = 100; -- default distance that player can open the chest from
        openSound = "chestOpen"; -- default open/close sounds.
        closeSound = "chestClose"
    }
}

```



Now for crafting:::
Crafting can be done through a "crafter" object.
```lua

local my_crafter = Crafter()

my_crafter:addRecipe(ingredients, result) -- adds a recipe to the crafter.

-- example:
my_crafter:addRecipe(
    {
        -- List of ingredients for a crafting recipe:
        {ingredient = "item_A", count = 6}; 
        -- where `ingredient` is an entity name, or an item name.
        {ingredient = "item_BC", count = 2};
        {ingredient = "item_cap", count = 1}
    },
    
    { result = "item_C";
      count = 16 } -- crafts 16 "item_C", where "item_C" is an entity name.
)



-- Creates a crafting table entity:
return chests.newCrafter({
    crafter = crafter; -- the crafting schematic to be used.

    craftItemLocation = {5, 1}; -- where the items get put after crafting
    craftButtonLocation = {5, 5}; -- where the craft button is
    
    openable = {
        distance = 100; -- default distance that player can open the chest from
        openSound = "chestOpen"; -- default open/close sounds.
        closeSound = "chestClose"
    }
})








```


