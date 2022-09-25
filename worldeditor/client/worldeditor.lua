
local newEntity = require("client.new_entity")


on("slabUpdate", function()
    newEntity.update()
end)


