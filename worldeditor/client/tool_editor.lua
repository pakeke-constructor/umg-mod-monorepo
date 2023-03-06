

local toolEditor = {}




local buildTypes = {}




--[[


TODO TODO:

We are gonna need a `context` object to keep track of the current
input state. 
Do some thinking about this.


]]


function buildTypes.number(id, key)
    Slab.Text(key)
    Slab.SameLine()
    if Slab.Input(tostring(id), {"Gonna needa use context object here!"}) then
        local number = Slab.GetInputNumber()
        return number
    end
end

function buildTypes.string(id, key)
    Slab.Text(key)
    Slab.SameLine()
    if Slab.Input(tostring(id)) then
        local number = Slab.GetInputString()
        return number
    end
end

function buildTypes.selection(id, opts)
    Slab.Text(key)
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(id), {Selected = Selected}) then
        for I, V in ipairs(Fruits) do
            if Slab.TextSelectable(V) then
                Selected = V
            end
        end
    
        Slab.EndComboBox()
    end
    
end





function toolEditor.addType(typeName, args)
    buildTypes[typeName] = args
end









return toolEditor

