



local tc = base.typecheck.assert("string", "function")

local runScript = {}



function runScript.compileScript(script, errFunc)
    tc(script, errFunc)
    local chunk, err = pcall(loadstring, script)
    if not chunk then
        return nil, "invalid syntax: " .. tostring(err)
    end

    return chunk
end



function runScript.runScript(chunk, ...)
    local success, err = pcall(chunk, ...)
    if not success then
        return nil, tostring(err)
    end
end


return runScript

