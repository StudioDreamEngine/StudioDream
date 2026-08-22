local GradientSequence = {}

--[[ SequenceTime can go 1 though 0!!! ]]

function GradientSequence.NewKey(Sec,Color)
    Utils.AssertType(Color, "Color")

    return {
        SequenceTime = math.clamp(Sec,0,1),
        Color = Color,
        Type = "ColorKey"
    }
end 

function GradientSequence.NewSequence(TableOf)
    Utils.AssertType(TableOf, "table")

    local SequenceObject = {
        Type = "GradientSequence"
    }

    local Keys = {}

    function SequenceObject.AddKey(Key)
        Utils.AssertType(Key, "ColorKey")
        Keys[Key.SequenceTime] = Key.Color
    end

    function SequenceObject.GetKeys()
        return Keys
    end

    for _,v in ipairs(TableOf) do -- Organize table and kills equal sequencetime colors
        SequenceObject.AddKey(v)
    end
    
    return SequenceObject
end

return GradientSequence