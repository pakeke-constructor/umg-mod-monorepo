
# CARD IDEAS:
## Format:  name, ATCK/HEALTH



### TIER 1 UNITS:::

# brute
melee, 4/4
on buy:
give a random [same color] ally 1/1

# huhu
// Usually should spawn in groups of 2.
melee, 1/1
on sell:
grant all [same color] huhus 2 x hp and 2 x dmg

# slime
melee, 1/4
start of turn:
gain +1 gold

# tanko
melee, 2/7
splash damage.
start of turn:
lose 1 max hp permanently


# squash
// same sprite as `brute`, but squashed (.sy = 0.6)
melee, 3/3
start of fight:
if no [same color] allies exist,
become a 7/7.


# pigbank
melee, 2/3
start of turn:
if this unit has been alive for exactly 3 rounds,
give `X` gold.
// TODO: Balance this amount of gold!!


# enhancer
melee, 2/2
on ally summoned:
if ally is [same color], give ally +1/1.





### TIER 2 UNITS:

# mage
ranged, 5/4
on buff:
gain +10% dmg

# imp
// This should be a swarm unit! (brute sprite scaled down)
melee, 2/2
on buy:
give all [same color] allies 2/2

# totem
ranged, 2/2
splash damage
on reroll:
gain +1 dmg

# healer
// brute sprite, but with angel wings maybe??
melee, 0/6
on damage:
heal all [same color] allies for 1 hp

# mimic
melee, 2/2
start of battle:
mimic the stats of the strongest [same color] ally

# mancer
ranged, 3/3
start of turn:
if this is the only [same color] ally on the board,
rerolling is discounted by `X`
// TODO:: put some exact numbers on this!!!

# shifter
melee, 2/6
on buy:
change all [same color] units to a random color.




### TIER 3 UNITS:

# hogger
melee, 3/3
end of turn:
steal 1/1 from all [different color] allies

# stun gob
// usually a swarm unit, groups of 3
melee, 2/2
on death:
stun all enemy units

# soldier
melee, 6/6
on buy:
if there are only [same color] allies on the board,
become a 15/15

# leader
melee, 5/5
end of turn:
give all [same color] allies 1/1

# buffer
melee, 4/7
end of turn:
give the strongest [same color] ally +15% hp and dmg

# monk
ranged, 2/5
on buff:
give all [same color] allies +10% dmg

# adaptor
melee, 5/7
on buy:
add [same color] to a random ally.
// For example, if ally is green, and adaptor is red,
// the ally becomes  RED + GRN = YLO.


### TIER 4 UNITS:

# witch
ranged, 3/10
on ally death:
if ally is [same color], summon a 1/1 huhu.

# catcher:
melee, 8/8
splash damage
on enemy stunned:
heal all [same color] allies by 5% of max hp

# gremlin
// usually a swarm unit, 3 of them
melee, 3/3
start of battle:
if there are only [same color] allies on the board,
this unit summons a copy of itself.

# elite
melee, 8/8
start of fight:
if there are only [same color] allies on the board,
become a 25/25

# symbiote
ranged, 10/1
redirect all damage to the healthiest [same color] ally

# pharos
melee, 4/7
start of battle:
give all [same color] ranged units splash damage


# priest
ranged, 5/2
splash damage
on buff:
give all [same color] allies +10% hp

// NOTE: priest and monk synergize together SUPER WELL!!!!
// They create a chain reaction of buffs.



