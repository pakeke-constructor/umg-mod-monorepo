


local CAMERA_PRIORITY = 0

local follow_x = 0
local follow_y = 0

local followGroup = umg.group("cameraFollow")


umg.on("@update", function()
    local sum_x = 0
    local sum_y = 0
    local len = 0

    for _, ent in ipairs(followGroup) do
        if ent.x and ent.y then
            sum_x = sum_x + ent.x
            sum_y = sum_y + ent.y - (ent.z or 0) / 2
            len = len + 1
        end
    end

    if len > 0 then
        follow_x = sum_x / len
        follow_y = sum_y / len
    end
end)


umg.answer("getCameraPosition", function()
    return follow_x, follow_y, CAMERA_PRIORITY
end)


