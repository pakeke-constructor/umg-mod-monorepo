
local runningNextTick = objects.Array()


local function nextTick(func, ...)
    local obj = {
        ...,
        func = func
    }
    runningNextTick:add(obj)
end


umg.on("@tick", function()
    for i, obj in ipairs(runningNextTick)do
        obj.func(unpack(obj))
    end
    runningNextTick:clear()
end)



return nextTick
