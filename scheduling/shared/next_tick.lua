
local runningNextTick = objects.Array()


local function nextTick(func, ...)
    local obj = {
        ...,
        func = func
    }
    runningNextTick:add(obj)
end


umg.on("@tick", function()
    -- clone to ensure that we dont prematurely delete functions that
    -- were added during iteration
    local cloned = runningNextTick:clone()
    runningNextTick:clear()

    for i, obj in ipairs(cloned) do
        obj.func(unpack(obj))
    end
end)



return nextTick
