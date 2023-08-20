
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


## Q3: How to handle exotic use types:

**Continuous item usage:**
- `usables:startUseContinuous` item starts being used
- `usables:useContinuous` (called every tick)
- `usables:endUseContinuous` item stops being used

**Charge item usage:**
- `usables:startCharge` item starts being charged
- `usables:releaseCharge` Charge released (eg. bow and arrow shot)
- `usables:cancelCharge` Cancelled (eg. not enough charge to properly use)



