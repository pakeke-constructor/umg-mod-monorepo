
# Dimensions mod

Allows separation of entities via keyword.

Think of a "dimension" as a realm where entities can exist in.




### DimensionVectors:
`DimensionVectors` are central to this mod.
They represent a concrete position in the universe.

They are just a table of the following shape:
```lua
{
    x = 1,
    y = 439,
    dimension = "nether" -- optional value (defaults to "overworld")
    z = 439, -- optional value (defaults to 0)
}
```

