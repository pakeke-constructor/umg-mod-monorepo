
local SHOULD_TEST = false --true
if SHOULD_TEST then
    require("shared._typecheck_tests")
    print("[typecheck mod] all tests passed")
end



umg.expose("typecheck", require("shared.typecheck"))

