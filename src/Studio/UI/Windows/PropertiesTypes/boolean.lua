local Boo = {}

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
        Image = "Assets/Icons/Engine/Boolean.png",
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

return Boo