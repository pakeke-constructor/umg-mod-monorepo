

--[[

file that handles the creation and editing of tools,
i.e. brushes, actions, lua-scripts, etc.



]]


local toolEditor = {}



local ToolNode = base.Class("worldeditor:ToolNode")

function ToolNode:init(params)
    for k,v in pairs(params) do
        self[k] = v
    end
end

function ToolNode:isDone()
    return self.done
end



local NumberNode = base.Class("worldeditor:NumberNode", ToolNode)
local StringNode = base.Class("worldeditor:StringNode", ToolNode)
local SelectionNode = base.Class("worldeditor:SelectionNode", ToolNode)
local ETypeNode = base.Class("worldeditor:ETypeNode", ToolNode)

-- this is what all the tools use:
local CustomNode = base.Class("worldeditor:CustomNode", ToolNode)




function NumberNode:display()
    Slab.Text(self.key)
    Slab.SameLine()
    if Slab.Input(tostring(self.id), {Text = tostring(self.value)}) then
        local value = Slab.GetInputNumber()
        if value then
            local ok = ((not self.max) or self.max <= value) and ((not self.min) or self.min >= value)
            if ok then
                self.done = true
                self.value = value
            end
        end
    end
end

function StringNode:display()
    Slab.Text(self.key)
    Slab.SameLine()
    if Slab.Input(tostring(self.id), {Text = tostring(self.value)}) then
        self.value = Slab.GetInputString()
        if self.value and (#self.value > 0) then
            self.done = true
        end
        return self.value
    end
end


function SelectionNode:display()
    assert(self.options, "must require options field for SelectionNode")
    Slab.Text(self.key)
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.selected}) then
        for _, opt in ipairs(self.options) do
            if Slab.TextSelectable(opt) then
                self.done = true
                self.selected = opt
            end
        end
        Slab.EndComboBox()
    end
end


local ALL_ETYPES = {} --  actually put the etypes in here

function ETypeNode:display()
    Slab.Text(self.key)
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.selected}) then
        for _, opt in ipairs(ALL_ETYPES) do
            -- TODO:
            -- An image should be shown of the entity. We should have a more
            -- detaled looking entity selection thing!!! Shouldnt just be names
            if Slab.TextSelectable(opt) then
                self.done = true
                self.selected = opt
            end
        end
        Slab.EndComboBox()
    end
end



local customColor = {0.5,0.5,1}

local buttonReadyColor = {0.2,0.8,0.3}


function CustomNode:display()
    Slab.Text(self.name, {Color = customColor})
    if _G.settings.showDescription and self.description then
        Slab.Text(self.description)
    end

    Slab.Separator()

    for _, child in ipairs(self.children) do
        local node = child.node
        node:display()
        Slab.Separator()
    end

    if self:isDone() then
        if Slab.Button("Done", {Color = buttonReadyColor}) then
           -- create the tool 
           -- TODO: What should we actually do here???
           -- probably send thru a CB.
        end
    end
end


function CustomNode:isDone()
    for _, child in ipairs(self.children) do
        if (not child.optional) and (not child.node:isDone()) then
            return false
        end
    end
    return true
end




--[[
    maps selection types to ui Nodes
]]
local typeMapping = {
    number = NumberNode,
    string = StringNode,
    etype = ETypeNode,
    selection = SelectionNode
}


function toolEditor.createNode(args)
    --[[
        args = {
            {
                type = "number",
                optional = true/false, 
                ...  -- extra args can be added
            }
        }
    ]]
    local nodes = base.Array()
    for _, arg in ipairs(args) do
        assert(arg.type and typeMapping[arg.type], "invalid")
        -- TODO: we need to add an ID here somehow
        nodes:add(
            typeMapping[arg.type](arg)
        )
    end
end



return toolEditor

