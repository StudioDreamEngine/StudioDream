local GradientSequence = {}

--[[ SequenceTime can go 1 though 0!!! ]]

function GradientSequence.NewKey(Time,Color)
    Utils.AssertType(Color, "Color")

    ---@class GradientKey
    return {
        SequenceTime = math.clamp(Time,0,1),
        Color = Color,
        Type = "ColorKey"
    }
end 

function GradientSequence.NewSequence(TableOf)
    Utils.AssertType(TableOf, "table")

    ---@class GradientSequence
    local SequenceObject = {
        Type = "GradientSequence"
    }

    local Keys = {}
    local Colors, Times = table.create(16, {1,1,0,1}), table.create(16, 0)

    function SequenceObject.AddKey(Key)
        Utils.AssertType(Key, "ColorKey")
        table.insert(Keys, {Key.SequenceTime, Key.Color})
    end

    function SequenceObject.GetKeys()
        return Keys
    end

    function SequenceObject.GetKeyLength()
        return table.length(Keys)
    end

    function SequenceObject.GetColors() return unpack(Colors) end
    function SequenceObject.GetTimes() return unpack(Times) end

    function SequenceObject.ProcessUniforms()
        for Index, Value in pairs(SequenceObject.GetKeys()) do
            local Time = Value[1] ---@class number
            local Color = Value[2].ToShader()

            Colors[Index] = Color
            Times[Index] = Time
        end
    end

    for _,v in ipairs(TableOf) do -- Organize table and kills equal sequencetime colors
        SequenceObject.AddKey(v)
    end
    
    return SequenceObject
end

return GradientSequence