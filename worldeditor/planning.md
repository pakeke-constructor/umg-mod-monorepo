

## Pre-planning:
Do we want to allow the game to be running whilst the worldeditor is active?
(probably, yes!)

But we ALSO want to allow worldediting whilst the game is paused!

We should just block all input if the client is worldediting







# WORLDEDITOR PLANNING:




# FILTERS:
Allows to filter entities based on one (or more) rules

## Selection 
Selection of an area
## FilterScript 
Takes an entity, and returns boolean if the entity matches the filter







ALL OF THE FOLLOWING SHOULD BE ABLE TO BE IMPORTED / EXPORTED:
## Brushes
Represent a rule that can be applied to one or more positions in the world
May contain:  SpawnRule, PointScript, Schematic

## Schematics
Represent saved groups of entities

## SpawnRule
Spawns a single entity given (x,y)
May contain: EntityScript, FilterScript  

## PointScript
Executes a script at a position, with input (x,y)

## EntityScript
Applies a script to an entity, with input (ent)






# COMMANDS:
Miscellaneous changes to a world  (e.g. worldborder, player spawn)

Commands should be deployed by other mods,
or by the worldeditor itself.
(For example, drawing the worldborder is a macro that tags onto the selection)


## PointCommand
Applied to a single point (x,y)
## SelectionCommand
Applied to a selection (x,y,w,h, entityList)

Commands should also be able to be used in scripts, via `worldeditor.commands.*`

