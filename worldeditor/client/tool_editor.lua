

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


local paramColor = {0.6,0.6,1}







function NumberNode:display()
    Slab.Text(self.param, {Color = paramColor})
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
    Slab.Text(self.param, {Color = paramColor})
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
    Slab.Text(self.param, {Color = paramColor})
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


local etypes = require("client.etypes")


function ETypeNode:display()        
    Slab.Text(self.param, {Color = paramColor})
    Slab.SameLine()
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.value}) then
        for _, opt in ipairs(etypes.etypeList) do
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




function CustomNode:pullParamsFromChildren()
    local params = {}
    assert(self:isDone(), "wat?")
    for _, child in ipairs(self.children) do
        params[child.node.param] = child.node:getValue()
    end
    return params
end


function CustomNode:display()
    if self.param then
        Slab.Text(self.param, {Color = paramColor})
    end

    if _G.settings.showDescription and self.description then
        Slab.Text(self.description)
    end

    Slab.Separator()

    if Slab.BeginTree("Params_" .. tostring(self.id), {Label = "Params:"}) then
        Slab.Indent()
        for _, child in ipairs(self.children) do
            local node = child.node
            node:display()
            Slab.Separator()
        end

        Slab.Unindent()
        Slab.EndTree()
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


function CustomNode:getValue()
    if self:isDone() then
        local params = self:pullParamsFromChildren()
        self.value = self.class(params)
        return self.value
    end
    return nil
end







function CustomNodeGroup:display()
    if self.param then
        Slab.Text(self.param, {Color = paramColor})
        Slab.SameLine()
    end
    assert(self.customNodes, "not given customNodes")
    if Slab.BeginComboBox(tostring(self.id), {Selected = self.value}) then
        for opt, nodeCtor in pairs(self.customNodes) do
            if Slab.TextSelectable(opt) then
                self.value = opt
                self.customNode = nodeCtor({
                    id = self.id + 1
                })
            end
        end
        Slab.EndComboBox()
    end

    if self.customNode then
        self.customNode:display()
    end
end


function CustomNodeGroup:getValue()
    if self.customNode then
        return self.customNode:getValue()
    end
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



local nodeGenAsserter = base.typecheck.assert("table", "string")

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
    nodeGenAsserter(args.params, args.description)

    return function(options)
        local id = options.id
        assert(type(id) == "number", "?")
        local children = base.Array()
        for _, arg in ipairs(args.params) do
            id = id + 1
            assert(typeMapping[arg.type], "invalid type: " .. tostring(arg.type))
            local argCopy = {}
            for k,v in pairs(arg) do
                argCopy[k] = v
            end
            argCopy.id = id
            children:add({
                id = id,
                optional = arg.optional,
                node = typeMapping[arg.type](argCopy)
            })
        end
        return CustomNode({
            param = options.param,
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
            description = cls.description,
            class = cls
        })
        if not cls.name then
            error("no name for a class w/ toolType: " .. tostring(classes[1].toolType))
        end
        customNodes[cls.name] = ctor
    end
    local customNodeGroupCtor = function(options)
        assert(type(options.id) == "number", "?")
        return CustomNodeGroup({
            id = options.id,
            customNodes = customNodes,
            param = options.param
        })
    end
    typeMapping[toolType] = customNodeGroupCtor
end



local brushes = require("shared.brushes")
local areaActions = require("shared.actions.area_actions")
local pointActions = require("shared.actions.point_actions")
local entityActions = require("shared.actions.entity_actions")


defineCustomNodeGroup(brushes)

defineCustomNodeGroup(areaActions)

defineCustomNodeGroup(pointActions)

defineCustomNodeGroup(entityActions)




function toolEditor.createBrushNode(id)
    return typeMapping.Brush({id = id})
end

return toolEditor

