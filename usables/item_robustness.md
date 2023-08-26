

# Q7 - Item robustness.

I made a new file for this, because it was getting too big.

---------------

Right now, giving x,y comps to inventory items are just.. not robust.
Lets plan a better way to do things.

Why is it not robust?
- We might forget to remove the (x,y) component when moving an item
- There are many sources of "truth" for whether an item should have (x,y)
    - (holdItem comp, x-y comps, inventory component)

We also want to be forward-thinking about this.
In the future, we will want to add items that have other unique
properties when they are in a certain inventory, i.e. armor, passive items,
etc etc.<br>
If we find a way to do this in a robust fashion, it'd be amazing.

-----------------------

#### Q7-SOLUTION-3-ALPHA
Perhaps we can allocate a "handler" or something to items within
an inventory?
YES. That's it. this has gotta be the solution
```lua
local itemHandle = inventory:createItemHandle(slotX, slotY)
-- returns an item handle for the item at (slotX, slotY)

local isValid = itemHandle:isValid() -- whether the handle is valid
local itemEnt = itemHandle:get() -- returns nil if invalid

```
See code above.
If an entity moves inventories, all of it's `handles` become invalid.
If an entity moves slots, it's handles also become invalid.
handles are managed internally by each inventory.

Ok, cool. This solves some of our problems, and will solve many more
problems down the line.
But this doesn't solve the (x,y) components still existing!

IDEA: create a `items:itemHandleInvalidated` callback,
passing in `(invEnt, itemHandle, itemEnt)`?
```lua
itemHandle:addFlag("removePosition", true)
local val = itemHandle:getFlag("removePosition")
```
That way, we could add flags to itemHandles (eg above) to automatically
apply properties to items:
```lua
umg.on("items:itemHandleInvalidated", function(invEnt, itemHandle, item)
    if itemHandle:getFlag("removePosition") then
        item:removeComponent("x")
        item:removeComponent("y")
    end
end)
```
Do some thinking.
Also, do we want `:getFlag`, `:setFlag` for this? Or do we just want
`itemHandle.removePosition = true`...?

#### Q7-SOLUTION-3-BRAVO
Instead of adding weird flags to the object,
just extend the `ItemHandle` and write directly to a method:
```lua
local extends = items.ItemHandle
local HoldItemHandle = objects.Class("usables:HoldItemHandle", extends)

function HoldItemHandle:onInvalidate(item)
    item:removeComponent("x")
    item:removeComponent("y")
end
```
I think this way is a lot better than the weird flags, since it's
just a bit more explicit, and the logic is better encapsulated.
- ^^^ IDIOT, This doesnt work, the inventory controls the concrete type
of the ItemHandler.

#### Q7-SOLUTION-3-CHARLIE
Ok.
So, the main source of the "problem" is that we want xy adding/removal
to be done in the same place.<br>
This is why the `ItemHandle` solution feels so darn good, because it's
a singular object that captures the entire operation of adding/remming xy.
So we definitely want to keep it.

Limitations / bad things about Q7-S3-ALPHA: 
- flag stuff is globally applied, which is yucky
    its fine for components to be global, because components are 
    well-defined. Its NOT okay for these flags to be global.
    Its weird, and yucky.

IDEA:  Super simple solution:
How about the `holding` system, during updating, just loops through all
of the holdItems, and removes components from any invalid handles?
After removing, the holdItem is set to nil, so it's guaranteed to not
be invalidated twice







### Old, discarded solutions:

#### Q7-SOLUTION-1
How about we create position management functionality within `Inventory`,
which keeps track of items that have a position?
Then, when the item moves out of the inventory, or is dropped,
then the item's position components can get destroyed.

This was *somewhat* similar to what we had before, but now it's just
able to be extended nicely:
API IDEA 1:
```lua
inv:allocatePosition(itemEnt, x, y)
-- allocates position for entity

inv:deallocatePosition(itemEnt)
-- de-allocates position

local hasPos = inv:isPositionAllocated(itemEnt)
-- Checks whether a position is allocated or not
```

#### Q7-SOLUTION-2
Deep-clone item ents when moving them across entities.<br>
WHAT? how tf is this related? (hear me out, okay)<br>
When an item is moved to another entity, it gets cloned, then deleted.
This means that if any component references an item entity, then
that item entity is GUARANTEED to exist only within that one inventory.
No more shenanigans, now all the systems tagging into items just
need to do a quick `umg.exists` check

Downside? This incurs a huge perf hit.
Deepcopying complex entities will be bad for perf.
Imagine a shulker-box in minecraft. Moving it across inventory
boundaries would invoke a deepcopy on all contained item entities...
terrible.<br>
Also- this would be fragile, since the deepCloned entity would inherit
the dodgy xy components.









## Final plan:
This is the best idea:

Have a slotHandler class:
```lua

local SlotHandler = Class()

...
...
...

function SlotHandler:itemRemoved(item)
    ... -- this function is overriden!
end

function SlotHandler:itemAdded(item)
    ... -- this function is overriden!
end
```

And a method in inv that takes a slotHandler object:
```lua
inv:setSlotHandler(slotX, slotY, slotHandler)
```

From there, we can extend the slotHandler to do custom stuff:
```lua
local HoldItemSlotHandler = Class(extends SlotHandler)
...
```

And we can add a slotHandler automatically given the components:
```lua
local group = umg.group("inventory", "holdItemSlot")

group:onAdded(function(ent)
    local inv = ent.inventory
    local his = ent.holdItemSlot

    local obj = HoldItemSlotHandler(...)
    inv:setSlotHandler(his.slotX, his.slotY, obj)
end)
```

