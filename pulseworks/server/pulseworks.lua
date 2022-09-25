
require("constants")




local wireMap = setmetatable({},{
    __index = function(t,k)
        t[k] = {}
        return t[k]
    end
})


