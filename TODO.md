

# DAY PLAN:



# IDEA:
  

Sometimes, you call `base.animateEntity` from serverside, and it errors.

It would be a lot better if there was something that directly told you
what the error is.

For example, if you call `base.animate` on serverside, (or any other 
clientside func,) you should get an error like:

```
This function works client-side only, but you called it on server-side.

HINT:  Callbacks, like onUpdate or onClick, are called on BOTH server and client.
You may want to have a check:

if client then 
    funcName(...)
end

This ensures that the code is only ran on clientside.
```

### OKAY: 
So these "serverside error functions" must be easily able to be defined.
Perhaps we should standardize an export API that automatically generates these
functions?
^^^ this is a great idea.
Something like:
```lua


local function loadServer(base)

local module1 = require("...")
local module2 = require("...")

function base.spawnEntity(...)
    ...
end

function base.doOtherThing()
    ...
end

end


base.defineExports({
    name = "base", 
    loadServer = loadServer,
    loadClient = loadClient,
    sharedFuncs = sharedFuncs
})
```
And then the error functions are generated from there for both clientside and
serverside.


