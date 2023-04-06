


base.defineExports({
    name = "attack",
    loadServer = function(attack)
        local api = require("server.attack")
        for k,v in pairs(api) do
            attack[k] = v
        end
    end;
})
