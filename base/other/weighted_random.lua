


local function weightedRandom(tabl)
    --[[
        tab : {
            ["foo"] = 0.1;  20% chance to pick "foo"
            ["bar"] = 0.4;  80% chance to pick "bar"
        }
    ]]

    local cumulative_weights = { }
    local values = { }

    local SUM = 0
    for value, weight in pairs(tabl) do
        if type(weight) ~= "number" then
            error("weightedRandom(tabl) takes a table of {[result] = weight} entries.")
        end
        SUM = SUM + weight
        table.insert(cumulative_weights, SUM)
        table.insert(values, value)
    end

    assert(#cumulative_weights > 0, "Need more options for weighted_selection!")
    assert(#values > 0, "Need more options for weighted_selection!")

    return function()
        local r = math.random() -- get random val (uniformly made double: 0 -> 1 )

        for i = 1, #cumulative_weights do
            local ke = cumulative_weights[i] / SUM
            if ke >= r then
                return values[i]
            end
        end

        return error("Oli made a mistake. Pls contact oli. DATA: " .. tostring(r))
    end
end


return weightedRandom

