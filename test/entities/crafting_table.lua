
local my_crafter = chests.Crafter()


my_crafter:addRecipe(
    {{ingredient = "item", count = 6}},
    {result = "musket"; count = 1}
)



my_crafter:addRecipe(
    {{ingredient = "musket", count = 1};
    {ingredient = "item", count = 2}},

    {result="pickaxe"; count=1} 
)



my_crafter:addRecipe(
    {{ingredient = "pickaxe", count = 1};
    {ingredient = "item", count = 2}},

    {result="musket"; count=1} 
)



return chests.newCraftingTable({
    "x","y",
    image = "crate",
    openable = {distance = 100};

    crafter = my_crafter;
    init = base.entityHelper.initPosition
})

