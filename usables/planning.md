
# REQUIREMENTS:

Stuff we need for now:
- A way to hold a single item
- Robustness w/ inventory system

Stuff we want in the future:
- Chargable items
- Repeatable items (ak-47)
- One-use items
- Continuous items (i.e. lazer beam)
- Holding multiple items




# PLANNING:


## Q1: How are items actually held?
Ideas:
- Keep it same as before (only 1 item can be held)
    ^^^ THIS IS THE BEST IDEA.
    If modders want to support multi-hold, they can add the 
    position components themselves and handle all that themselves.
- `holditems` component: A `Set<ItemEnt>` of items that are being held
- Set holdItems manually, and an internal system handles it.



## Q2: What are we doing with the argument order for `items:useItem`?
Args should look like this:
`(itemEnt, holderEnt, useMode, ...)`
where `useMode` is a number.



## Q3: How do we handle exotic use types?
Items should be able to be continuous AND chargable simultaneously.

**Components:**
```lua
item.itemChargeTime = X -- time taken to charge this item
item.itemRepeatUsage = true -- repeats usage whilst being used (like ak47)
```

Emit the following callbacks:
- `usables:itemStartCharge` item starts being charged
- `usables:itemBeingCharged` called every tick whilst charging (pass in time)
- `usables:itemUse` item starts being used
- `usables:itemBeingUsed` called every tick whilst using (pass in time)
- `usables:itemEndUse` item stops being used
- `usables:itemCancelCharge` Cancelled (not charged for enough time)




## Q4: How do we interact with the mod to say which items are held?
We can only equip items if the entity has an inventory:
```lua
usables.equipItem(ent, invX, invY) -- where (invX, invY) are inventory coords
usables.unequipItem(ent, invX, invY)
```
TODO: Where do we actually store the info for hold items?
idea: `ent.holdItem` component, which contains `slotX`, `slotY` values.


## PROBLEM 1:
There is a potential for problems with item entities:
Items may end up with position components, even when they are no longer
being held.

## PROBLEM 2:
How do we handle syncing for holdItems?
Solutions

## PROBLEM 3:
How do we handle switching between items?
idea:
- use number keys for quick switching
- use mouse scroll for switching like minecraft

