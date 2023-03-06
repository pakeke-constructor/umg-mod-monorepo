

## Pre-planning:
Do we want to allow the game to be running whilst the worldeditor is active?
(probably, yes!)

But we ALSO want to allow worldediting whilst the game is paused!

We should just block all input if the client is worldediting







# WORLDEDITOR PLANNING:

Basic stuff we want to ensure that we do:

Copy-Paste
Selection of areas
Brushes, (create or delete entities)
Undo / Redo  (<-- THIS IS HARD. Do through Actions perhaps?)





ALL OF THE FOLLOWING SHOULD BE ABLE TO BE IMPORTED / EXPORTED:

# FILTERS:
Allows to filter entities based on one (or more) rules
FUNCS:
`filter:filter(ent)  -->  true/false`

## TypeFilter 
params: `entityType`
Filter entities by type
## FilterScript 
params: `luaScript`
Takes an entity, and returns boolean if the entity matches the filter
## ComponentFilter
params: `component`
Filter entities by component ownership




# === Brush ===:
Brush that can be applied to one or more positions in the world.
FUNCS:
`brush:apply(x, y)`

## PointBrush
params: `PointAction`
pointBrush only acts on one point
## SquareBrush
params: `AreaAction`
SquareBrush acts on an area
## ClusterBrush (TODO, DO THIS LATER ON)
ClusterBrush acts on multiple square areas








## === AreaAction ===
AreaActions act on an area
FUNCS:
`let Area = {x=x, y=y, w=w, h=h}`
`areaAction:apply(area: Area, excludeArea: Area)`

## AreaScriptAction
params: `luaScript`
Applies a script with input (x,y,w,h)
## AreaEntityAction
params: `EntityAction`, `Filter = nil`
Takes an area, and applies an action to all entities in the area
## AreaRandomPointAction
params: `numPoints`, `type="normal"|"uniform"`, `minDistance`, `PointAction`
Takes an area, generates random points, and applies an action to every point
## AreaGridPointAction
params: `pointGapX`, `pointGapY`, `PointAction`
Takes an area, generates points in a grid, and applies an action to every point
## AreaSelection
Adds the current area to the global selection
## AreaCommand
params: `command`
Applies a command to an area






## === EntityAction ===
EntityActions act on an entity
FUNCS:
`entityAction:apply(ent)`

## EntityScript
params: `luaScript`
Applies a script to an entity
## EntityCommand
params: `command`
Applies a command to an entity







# === PointAction ===:
PointActions act on a single position
`pointAction:apply(x, y)`

### PointScript
params: `luaScript`
Executes a script at a position, with input (x,y)
### PointSpawn
params: `entityType`, `entityAction = nil`
Spawns a single entity given (x,y),   applies action if supplied
## PointCommand
params: `command`
Applies a command to a point










# COMMANDS:
Miscellaneous changes to a world  (e.g. worldborder, player spawn)

Commands should be deployed by other mods,
or by the worldeditor itself.
(For example, drawing the worldborder is a macro that tags onto the selection)


## PointCommand
Applied to a single point (x,y)
## AreaCommand
Applied to a selection (x,y,w,h, entityList)

Commands should also be able to be used in scripts, via `worldeditor.commands.*`

