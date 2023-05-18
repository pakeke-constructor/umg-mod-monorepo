

local targets = {}

local Target = base.Class("rgb-chess:Target")


local nameToTarget = {--[[
    [name] = Target
]]}


function targets.getTarget(name)
    return nameToTarget[name]
end



function Target:init(options)
    assert(options.name, "?")
    assert(options.getTargets, "?")
    assert(options.description, "?")
    local tdes = type(options.description)
    assert(tdes == "string" or tdes == "function", "?")

    assert(not nameToTarget[options.name], "duplicate target def")
    nameToTarget[options.name] = self

    for k,v in pairs(options)do
        self[k] = v
    end
end



function Target:drawSlabUI()
    local txt = self.description
    Slab.Text(txt)
end


function Target:getTargets(...)
    return self.getTargets(...)
end




Target({
    name = "matching",
    getTargets = function(sourceEnt)
        local buffer = base.Array()
        for _, ent in rgb.getBoard(sourceEnt.rgbTeam):iterUnits()do
            if ent ~= sourceEnt and rgb.match(sourceEnt, ent) then
                buffer:add(ent)
            end
        end
        return buffer
    end,
    description = "For all matching allies:"
})



Target({
    name = "matchingSelfIncluded",
    getTargets = function(sourceEnt)
        local buffer = base.Array()
        for _, ent in rgb.getBoard(sourceEnt.rgbTeam):iterUnits() do
            if rgb.match(sourceEnt, ent) then
                buffer:add(ent)
            end
        end
        return buffer
    end,
    description = "For all matching allies, including self:"
})




Target({
    name = "unmatching",
    getTargets = function(sourceEnt)
        local buffer = base.Array()
        for _, ent in rgb.getBoard(sourceEnt.rgbTeam):iterUnits()do
            if not rgb.match(sourceEnt, ent) then
                buffer:add(ent)
            end
        end
        return buffer
    end,
    description = "For all non-matching allies:"
})





return targets

