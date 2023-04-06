


base.defineExports({
    name = "attack",
    loadServer = function(attack)
        attack.attack = require("server.attack")
    end;
})
