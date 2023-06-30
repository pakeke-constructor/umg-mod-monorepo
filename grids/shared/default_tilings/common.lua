

local common = {}

local function isImage(image, argName)
    if image and client.assets.images[image] then
        return true
    end
    return nil, "Unknown image for " .. argName .. ": " .. tostring(image)
end


local function isImageArray(arr, argName)
    for _, img in ipairs(arr) do
        local ok,err = isImage(img)
        if not ok then
            return nil, "Bad image array for " .. argName .. "  " .. err
        end
    end
    return true
end



local tc = typecheck.assert("table", "string", "table", "table")
function common.add(args, argName, array, tiling)
    tc(args, argName, array, tiling)
    local img = args[argName]
    if not img then
        error("Missing tile type: " .. argName, 2)
    end

    if type(img) == "table" then
        -- then it's a random list of images
        assert(isImageArray(img, argName))
        tiling.images = img
    else
        assert(isImage(img, argName))
        tiling.image = img
    end

    table.insert(array, tiling)
end




return common

