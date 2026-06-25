local Bool = {}

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(128,0),
    ["nil"] = Vector2.new(0,0)
}

local function UpdateButton(Property,Button)
    Button:SetImageRect(Rect.new(LineUp[tostring(Property)],Vector2.new(64,64)))
end

function Bool.Start(MainInfo)

    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/Boolean.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = MainInfo.Option,
    }

    for i,Info in pairs(MainInfo.WillHandle) do -- on the start it will aways have 1 so ye
        UpdateButton(Info.Thing[Info.Property],Button)
    end

    table.insert(MainInfo.Connections,Button.Clicked:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do  
            -- Problems: Doesnt set display as "nil" if one of them are diferent, Just can inverse everyone out for now (if one of them are diferrent maybe make an looper?? so that doesnt happend)
            local CurrentVal = Info.Thing[Info.Property]
            Runtime.Things.SetProperty(Info.Thing,Info.Property,(not CurrentVal))
            UpdateButton(Info.Thing[Info.Property],Button) -- MAKE THIS AS A "NIL" DISPLAY IF ONE OF THEM ARE DIFERENT!! IDK HOW TO DO IT NOW BUT DO IT!!
        end
    end))

end

return Bool

--[[local Boo = {}

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(128,0),
    ["nil"] = Vector2.new(0,0)
}

local Size = Vector2.new(64,64)

local function UpdateButton(Button,Property)
    Button:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
end

function Boo.Start(FrameOption,Thing,Property)
    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/Boolean.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Parent = FrameOption,
    }

    UpdateButton(Button,Thing[Property])

    Button.Clicked:Connect(function()
        print("Hi")
        Thing[Property] = not Thing[Property] -- works sometimes????
        UpdateButton(Button,Thing[Property])
    end)
end

return Boo]]