


local function loadClient(zoom)
    local zoom_export = require("client.zoom")
    for name,func in pairs(zoom_export) do
        zoom[name]=func
    end
end




base.defineExports({
    name = "zoom",
    loadClient = loadClient
})



