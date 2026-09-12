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

function GradientSequence.NewSequence(TableOf, Rotation)
    Utils.AssertType(TableOf, "table")

    ---@class GradientSequence
    local SequenceObject = {
        Type = "GradientSequence",
        Rotation = Rotation or 0
    }

    local Keys = {}
    local Colors, Times
    local ID = 0

    function SequenceObject.AddKey(Key)
        ID = ID + 1

        Utils.AssertType(Key, "ColorKey")
        table.insert(Keys, {Key.SequenceTime, Key.Color, ID})

        return ID
    end

    function SequenceObject.GetKeys()
        return Keys
    end

    function SequenceObject.GetKeyLength()
        return table.length(Keys)
    end

    function SequenceObject.RemoveKeyByID(ID)
        for i,Key in pairs(Keys) do
            if Key[3] == ID then
                Keys[3] = nil
            end
        end
    end

    function SequenceObject.GetKeyByID(ID)
        for i,Key in pairs(Keys) do
            if Key[3] == ID then
                return Key
            end
        end
    end

    function SequenceObject.GetColors() return unpack(Colors) end
    function SequenceObject.GetTimes() return unpack(Times) end

    local function ProcessUniform(Index, Value)
        local Time = Value[1] ---@class number
        local Color = Value[2].ToShader()

        Colors[Index] = Color
        Times[Index] = Time
    end

    function SequenceObject.ProcessUniforms()
        Colors, Times = table.create(16, {1,1,0,1}), table.create(16, 0)

        table.sort(Keys, function (a, b)
            return a[1] < b[1]
        end)

        for Index, Value in pairs(Keys) do
            ProcessUniform(Index, Value)
        end

        local LastKey = Keys[#Keys]
        ProcessUniform(#Keys+1, {
            LastKey[1]+1,
            LastKey[2]
        })
    end

    for _,v in ipairs(TableOf) do -- Organize table and kills equal sequencetime colors
        SequenceObject.AddKey(v)
    end
    
    return SequenceObject
end

return GradientSequence