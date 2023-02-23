
# TODO:



Slab integration for inventories


ideation:
```lua

ent.inventoryUI = {
    -- inventories can have multiple places where you can render UI to
    -- Here's an example of one:
    {
        render = function(ent)
            -- Note that we don't need to generate a Slab window here!
            -- We can use Slab directly which is cool :)
            if Slab.Button(...) then
                ent.crafter:craft(...) -- etc
            end
        end,

        -- here's the viewport of the inventory UI widget
        width = 100,
        height = 100,
        x = 10,
        y = 10,
        color = {...}
    },


    {
        ... -- another place where UI could be rendered,
        -- same as the above.
    }
}





```


