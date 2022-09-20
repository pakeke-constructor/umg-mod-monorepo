

# DAY PLAN:
9:40 - 10:10 ::: Work on rgb_chess (Game planning! Try for emergence)


10:10 - 10:30 ::: break, breakfast

10:30 - 11:30 ::: Apply for steam, get documents thru.
            After you are done for that, work on rgb_chess
RGB_CHESS TASKS:
Get selection of Squadrons working (able to see unit stats too) (use Slab??)
Get selling of units working (make it able to sell whole squadrons)



11:30 - 11:40 ::: break

11:40 - 12:20 ::: Work on terrain mod

12:20 - 12:40 ::: break

12:40 - 1:30 ::: work on mod downloading/uploading (via steamworks SDK)

  
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
base.defineExports({
    name = "exportName", 
    serverFuncs = serverFuncs, 
    clientFuncs = clientFuncs, 
    sharedFuncs = sharedFuncs
})
```
And then the error functions are generated from there for both clientside and
serverside.


