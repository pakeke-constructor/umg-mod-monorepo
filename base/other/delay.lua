


local times = {}
--[[
Each `delay` object is represented as a table:
{
    ...  --> the arguments to the function
    func = func -- The func is constructed with varargs saved as a closure (bad but oh well)
    time = time
}
]]


local function binarySearch(arr, target_time)
    --[[
        returns what the index should be for a target time in `arr`.
        (This function will ensure that the list remains sorted)
    ]]
	local low = 1
	local high = #arr
	while low <= high do
		local mid = math.floor((low + high) / 2)
		local mid_val = arr[mid]
		if target_time > mid_val.endTime then
			high = mid - 1
		else
			low = mid + 1
		end
	end
    return low
end


local function delay(time, func, ...)
    local obj = {
        func = func;
        endTime = timer.getTime() + time,
        ...
    }
    local index = binarySearch(times, obj.endTime)
    table.insert(times, index, obj)
end




on("update", function()
    local time = timer.getTime()
    local i = #times
    while (i>0) and (time >= times[i].endTime) do
        local obj = times[i]
        times[i] = nil
        obj.func(unpack(obj))
        i = i - 1
    end
end)



return delay
