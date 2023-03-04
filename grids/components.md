
# components

imageTiling component:

```lua

--[[

layout component is done like so:


`#` indicates existance of a tile.
`.` indicates no tile.

`?` is wildcard: tile may or may not exist.

The center `X` represents the tile in question
(i.e. the entity whos image is being selected.)

]]

ent.imageTiling = {
    {
        image = "horizontalFence",
        layout = {
            {"?",".","?"},
            {"#","X","#"},
            {"?",".","?"},
        },
        priority = 0 -- the priority of this layout (higher = selected first)
    },
    {
        image = "verticalFence",
        layout = {
            {"?","#","?"},
            {".","X","."},
            {"?","#","?"},
        }
    },
    {
        image = "topRightFence",
        layout = {
            {"?",".","?"},
            {"#","X","."},
            {"?","#","?"},
        },
        canRotate = true, -- rotations of this layout will match
        canFlipHorizontal = true, -- flipped layouts match (ent.sx = -1)
        canFlipVertical = true, -- flipped layouts match (ent.sy = -1)
    },
    {
        image = "defaultFence",
        layout = { -- question mark implies wildcard. (can be anything)
            {"?","?","?"},
            {"?","X","?"},
            {"?","?","?"},
        },
        priority = -1 -- low priority
    }
}


```

