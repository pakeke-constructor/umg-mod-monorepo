
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
- `holditems` component: A `List<ItemEnt>` of items that are being held
    ^^^ this is the best idea
- Set holdItems manually, and an internal system handles it.
- Keep it same as before (only 1 item can be held) <--- BAD!!!



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



