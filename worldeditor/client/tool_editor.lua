

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

function ToolNode:getValue()
    return self.value
end




local NumberNode = base.Class("worldeditor:NumberNode", ToolNode)
local StringNode = base.Class("worldeditor:StringNode", ToolNode)
local SelectionNode = base.Class("worldeditor:SelectionNode", ToolNode)
local ETypeNode = base.Class("worldeditor:ETypeNode", ToolNode)

-- this is what all the tools use:
local CustomNode = base.Class("worldeditor:CustomNode", ToolNode)

-- These represent a class of similar tools.
-- (this is what customNodes are contained inside)
local CustomNodeGroup = base.Class("worldeditor:CustomNodeGroup", ToolNode)






function NumberNode:display()
    Slab.Text(self.param)
    Slab.SameLine()
    if Slab.Input(tostring(self.id), {Text = tostring(self.value), ReturnOnText = false, NumbersOnly = true}) then
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
    Slab.Text(self.param)
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
    Slab.Text(self.param)
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.value}) then
        for _, opt in ipairs(self.options) do
            if Slab.TextSelectable(opt) then
                self.done = true
                self.value = opt
            end
        end
        Slab.EndComboBox()
    end
end


local ALL_ETYPES = {} --  actually put the etypes in here

function ETypeNode:display()
    Slab.Text(self.param)
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.value}) then
        for _, opt in ipairs(ALL_ETYPES) do
            -- TODO:
            -- An image should be shown of the entity. We should have a more
            -- detaled looking entity selection thing!!! Shouldnt just be names
            if Slab.TextSelectable(opt) then
                self.done = true
                self.value = opt
            end
        end
        Slab.EndComboBox()
    end
end



local customColor = {0.5,0.5,1}

local buttonReadyColor = {0.2,0.8,0.3}



function CustomNode:pullParamsFromChildren()
    local params = {}
    assert(self:isDone(), "wat?")
    for _, child in ipairs(self.children) do
        params[child.param] = child.node:getValue()
    end
    return params
end


function CustomNode:display()
    Slab.Text(self.param, {Color = customColor})
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
        if (not self.value) or Slab.Button("Apply", {Color = buttonReadyColor}) then
            local params = self:pullParamsFromChildren()
            self.value = self.class(params) 
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








function CustomNodeGroup:display()
    Slab.Text(self.param)
    assert(self.customNodes, "not given customNodes")
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.value}) then
        for opt, nodeCtor in pairs(self.customNodes) do
            if Slab.TextSelectable(opt) then
                self.value = opt
                self.customNode = nodeCtor(self.id + 1)
            end
        end
        Slab.EndComboBox()
    end

    if self.toolNode then
        self.toolNode:display()
    end
end


function CustomNodeGroup:getValue()
    return self.customNode:getValue()
end


function CustomNodeGroup:isDone()
    return self.customNode and self.customNode:isDone()
end





--[[
    maps selection types to ui Nodes.
    Everything in here maps to a function (or class) that generates a Node.
]]
local typeMapping = {
    number = NumberNode,
    string = StringNode,
    etype = ETypeNode,
    selection = SelectionNode
}



local nodeGenAsserter = base.typecheck.assert("number", "table", "string", "string")


local function customNodeGenerator(args)
    --[[
        args : {
            param = "paramName",
            description = "description",
            class = class,

            params = {
                {
                    param = "myParam"
                    type = "number",
                    optional = true/false,

                },
                {
                    ...
                }
            }
        }
    ]]
    for _, param in ipairs(args.params) do
        assert(param.param, "param has no name")
        assert(param.type, "param has no type")
    end
    assert(args.class, "Not given tool constructor")

    return function(id)
        nodeGenAsserter(id, args.arguments, args.name, args.description)
        local children = base.Array()
        for _, arg in ipairs(args.arguments) do
            id = id + 1
            assert(typeMapping[args.type], "invalid type")
            children:add({
                id = id,
                optional = arg.optional,
                node = typeMapping[args.type](arg)
            })
        end
        return CustomNode({
            param = args.param,
            class = args.class,
            description = args.description,
            children = children,
            id = id
        })
    end
end




local function defineCustomNodeGroup(classes)
    local toolType = classes[1].toolType
    assert(toolType, "not given toolType: " .. tostring(classes[1]))
    for _, cls in ipairs(classes) do
        assert(cls.toolType == toolType, "invalid grouping")
    end

    local customNodes = {}
    for _, cls in ipairs(classes) do
        local ctor = customNodeGenerator({
            params = cls.params,
            name = cls.name,
            description = cls.description,
            class = cls
        })
        customNodes[cls.name] = ctor
    end
    local customNodeGroupCtor = function(id)
        return CustomNodeGroup({
            id = id,
            customNodes = customNodes,
            
        })
    end
    typeMapping[toolType] = customNodeGroupCtor
end



local brushes = require("shared.brushes")
local areaActions = require("shared.actions.area_actions")
local pointActions = require("shared.actions.point_actions")



defineCustomNodeGroup({
    brushes.SquareBrush,
    brushes.PointBrush
})

defineCustomNodeGroup({
    areaActions.AreaRandomPointAction,
    areaActions.AreaGridPointAction
})

defineCustomNodeGroup({
    pointActions.PointSpawn
})




function toolEditor.createBrushNode(id)
    return typeMapping.Brush(id)
end

return toolEditor

