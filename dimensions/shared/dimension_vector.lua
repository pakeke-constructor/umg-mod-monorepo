
--[[

DimensionVector class.
Used to represent a position in the universe.
(x,y,z and dimension values)

A DimensionVector is an object of the following shape:

dVector {
    x: number,
    y: number,
    dimension: string?
    z: number? 
}


`dimension` and `z` are optional values.
z defaults to 0,
dimension defaults to the default dimension.

x,y values are compulsory.


Note that entities can be used in place of dimensionVectors,
provided they have x,y components.

This makes dimensionVectors super useful, as we can create "abstract"
functions that can take either a DimensionVector, or an entity.

]]




--[[
    DimensionVectors don't have any special methods or anything
    bound to them.
    They are just POD.
]]


local ndvTc1 = typecheck.assert("number", "number", "string?", "number?")
local ndvTc2 = typecheck.assert({
    x = "number",
    y = "number",
    dimension = "string?",
    z = "number?"
})

local function newDimensionVector(tabl_or_x, y, dimension, z_or_nil)
    if type(tabl_or_x) == "number" then
        ndvTc1(tabl_or_x, y, dimension, z_or_nil)
        return {
            x = tabl_or_x,
            y = y,
            dimension = dimension,
            z = z_or_nil
        }
    end

    if type(tabl_or_x) == "table" then
        ndvTc2(tabl_or_x)
        local e = tabl_or_x
        return {
            x = e.x,
            y = e.y,
            z = e.z,
            dimension = e.dimension,
        }
    end

    error("invalid input to DimensionVector ctor: " .. tostring(tabl_or_x))
end





local MSG = "expected DimensionVector"

local function check(dvec)
    if type(dvec) ~= "table" then
        return false, MSG
    end
    return dvec.x and dvec.y, MSG
end

--[[
    typecheck interoperability
]]
typecheck.addType("dvector", check)
typecheck.addType("dimensionvector", check)



return newDimensionVector

