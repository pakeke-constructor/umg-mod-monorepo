
--[[
    TODO:
    Create a reuseable script generator here.
    This should be able to be reused by other mods,
    such as worldeditor.

    Put a warning to the user!!! (this could crash client)

    Also allow the user to decide whether it runs on server / client.

    The UI function should return a lua chunk.
]]


local currentScript = nil

local scriptRunner = {}



local RUN_OPTIONS = {
    SERVER = "SERVER",
    CLIENT = "CLIENT",
    SHARED = "SHARED",

    "SERVER","CLIENT","SHARED"
}


local KW_COLOR = {1,0.1,0.1}

local luaKeywords = {
    "and" , "break" , "do" , "else" , "elseif" , 
    "end" , "false" , "for" , "function" , "if" , "in" , 
    "local" , "nil" , "not" , "or" , "repeat" , "return" , 
    "then" , "true" , "until" , "while"
}

local luaHighlight = {}

for _,kw in ipairs(luaKeywords) do
    luaHighlight[kw] = KW_COLOR
end





client.on("chatCommandsOpenScript", function()
    currentScript = scriptRunner.newScriptObject()
end)



function scriptRunner.newScriptObject()
    return {
        script = "",
        side = RUN_OPTIONS.SERVER
    }
end





local WARNING_OPT = {Color = {0.8,0,0}}

function scriptRunner.scriptUI(scriptObject)
    Slab.BeginWindow("scriptRunner", {Title = "Lua Script"})
    Slab.Text("Warning: Scripts may corrupt your world!", WARNING_OPT)
    Slab.Text("If you are worried, make a backup", WARNING_OPT)
    Slab.NewLine()
    
    if Slab.Input("script", {Text = currentScript.script, MultiLine = true, Highlight = luaHighlight, W = 500, H = 400}) then
        currentScript.script = Slab.GetInputText()
    end

    if Slab.Button("Run", {Color = {0.5,1,0.5}}) then

    end
    Slab.EndWindow()
end



umg.on("ui:slabUpdate", function()
    if currentScript then
        scriptRunner.scriptUI(currentScript)
    end
end)


