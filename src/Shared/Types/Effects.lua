local Effects = {}

local Types = {
    ["chorus"] = {
        WaveForm = Enum.Waveform.Triangle,
        Phase = 90,
        Rate = 1.1,
        Depth = 0.1,
        Feedback = 0.25,
        Delay = 0.016,
    },
    ["compressor"] = {
        Enabled = true,
    },
    ["distortion"] = {
        Gain = 0.2,
        Edge = 0.2,
        Lowcut = 8000,
        Center = 3600,
        BandWidth = 3600
    },
    ["echo"] = {
        Delay = 0.1,
        TapDelay = 0.1,
        Damping = 0.5,
        Feedback = 0.5,
        Spread = -1
    },
    ["equalizer"] = {
        LowGain	= 1,
        LowCut = 200,
        LowMidGain = 1,
        LowMidFrequency	= 500,
        LowMidBandWidth	= 1,
        HighMidGain	= 1,
        HighMidFrequency = 3000,
        HighMidBandWidth = 1,
        HighGain = 1,
        HighCut	= 6000,
    },
    ["flanger"] = {
        WaveForm = Enum.Waveform.Triangle,
        Phase = 0,
        Rate = 0.27,
        Depth = 1,
        Feedback = -.5,
        Delay = 0.002,
    },
    ["reverb"] = {
        Gain=0.32,
        Highgain=0.89,
        Density=1,
        Diffusion=1,
        Decaytime=1.49,
        DecayHighRatio=0.83,
        EarlyGain=0.05,
        EarlyDelay=0.05,
        LateGain=1.26,
        LateDelay=0.011,
        RoomRolloff=0,
        AirAbsorption=0.994,
        HighLimit=true,
    },
    ["ringmodulator"] = {
        WaveForm = Enum.Waveform.Sine,
        Frequency = 400,
        HighCut = 800,
    }
}

function Effects.new(Name,Type)
    local EffectObj = {}

    EffectObj.Type = "Effect"
    EffectObj.EffectType = Type
    EffectObj.Name = Name
    EffectObj.Settings = setmetatable({},{
        __index = Types[string.lower(Type)],
        __newindex = function(_,Key,Value)
            EffectObj._UPDATED.Invoke()
            EffectObj:ToLOVE()
            rawset(EffectObj.Settings,Key,Value)
        end,
    })

    EffectObj.LOVE = nil
    EffectObj._UPDATED = Signal:New("EffectObjUpdate") -- This will be used on Audio-SetEffect link

    function EffectObj:ToLOVE()
        local NewTable = {}
        NewTable.type = string.lower(EffectObj.EffectType)
        for i,v in pairs(EffectObj.Settings) do
            NewTable[string.lower(i)] = v
        end

        EffectObj.LOVE = NewTable
        return EffectObj.LOVE
    end

    EffectObj:ToLOVE()

    return EffectObj
end

return Effects