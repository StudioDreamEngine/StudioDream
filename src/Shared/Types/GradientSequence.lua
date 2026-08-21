local GradientSequence = {}

--[[ SequenceTime can go 1 though 0!!! ]]

function GradientSequence.NewColorkey(Sec,Color)
    return {
        SequenceTime = Sec,
        Color = Color,
        Type = "ColorKey"
    }
end 

function GradientSequence.NewSequence(TableOf)
    if Utils.TypeOf(TableOf) ~= "Table" then
        assert("Table expected, got "..Utils.TypeOf(TableOf))
    end
    local BuildNewTable = {}

    for i,v in ipairs(TableOf) do -- Organize table and kills equal sequencetime colors
        if Utils.TypeOf(v) == "ColorKey" then
            BuildNewTable[v.SequenceTime] = Color
        else
            assert(Utils.TypeOf(v).." ins't a ColorKey Type")
        end
    end

    BuildNewTable.Type = "GradientSequence"
    
    return BuildNewTable
end

return GradientSequence