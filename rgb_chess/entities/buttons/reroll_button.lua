

local frames = {1,2,3,4,5,4,3,2,1}
for i=1, #frames do
    frames[i] = "button" .. tostring(i)
end


return {
    "x", "y",
    image = "button1",

    onClick = function(ent)
        base.animateEntity(ent, frames, 0.35)
    end,
}


