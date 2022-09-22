
# CARD IDEAS:
## Format:  name, ATCK/HEALTH



### TIER 1 UNITS:::


# arrowdude
melee, 3/8
on turn start:
grant all ranged [color] allies +2 dmg

# brute
melee, 4/15
on buy:
give a random [color] ally 1/4

# enhancer
melee, 2/2
on ally summoned:
if ally is [color], give ally +2/3.

# huhu
// Usually should spawn in groups of 2.
melee, 1/3
on sell:
grant all [color] huhus 2 x hp and 2 x dmg

# slime
melee, 1/15
start of turn:
if there are at least 2 [color] allies
gain +2 gold

# squash
// same sprite as `brute`, but squashed (.sy = 0.6)
melee, 3/10
start of fight:
if no [color] allies exist,
become a 9/50.

# tanko
melee, 2/35
splash damage.
start of turn:
lose 3 max hp permanently




### TIER 2 UNITS:

# mage
ranged, 5/4
buffs are 30% more effective for this unit


# imp
// This should be a swarm unit! (brute sprite scaled down)
melee, 2/2
on buy:
give all [color] allies 2/2

# totem
ranged, 2/2
splash damage
on reroll:
gain +1 dmg

# healer
// brute sprite, but with angel wings maybe??
melee, 0/6
on damage:
heal all [color] allies for 1 hp

# mimic
melee, 2/2
start of battle:
mimic the stats of the strongest [color] ally

# mancer
ranged, 3/3
start of turn:
if this is the only [color] ally on the board,
rerolling is discounted by `X`
// TODO:: put some exact numbers on this!!!

# shifter
melee, 2/6
on buy:
change all [color] units to a random color.




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
if there are only [color] allies on the board,
become a 15/15

# leader
melee, 5/5
end of turn:
give all [color] allies 1/1

# buffer
melee, 4/7
end of turn:
give the strongest [color] ally +15% hp and dmg

# monk
ranged, 2/3
on buff:
give all [color] allies +10% dmg

# adaptor
melee, 5/7
on buy:
add [color] to a random ally.
// For example, if ally is green, and adaptor is red,
// the ally becomes  RED + GRN = YLO.


### TIER 4 UNITS:

# witch
ranged, 3/10
on ally death:
if ally is [color], summon a 1/1 huhu.

# catcher:
melee, 8/8
splash damage
on enemy stunned:
heal all [color] allies by 5% of max hp

# gremlin
// usually a swarm unit, 3 of them
melee, 3/3
start of battle:
if there are only [color] allies on the board,
this unit summons a copy of itself.

# elite
melee, 8/8
start of fight:
if there are only [color] allies on the board,
become a 25/25

# symbiote
ranged, 10/1
redirect all damage to the healthiest [color] ally

# pharos
melee, 4/7
start of battle:
give all [color] ranged units splash damage


# priest
ranged, 5/2
splash damage
on buff:
give all [color] allies +10% hp

// NOTE: priest and monk synergize together SUPER WELL!!!!
// They create a chain reaction of buffs.



