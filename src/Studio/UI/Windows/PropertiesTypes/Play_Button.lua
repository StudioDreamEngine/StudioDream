local Template = {}

local LineUp = {
        ["play"] = Vector2.new(64,0),
        ["pause"] = Vector2.new(0,0),
    }

function Template.Start(FrameOption,Thing,Property,BaseProperty) -- Scrapped for now
    BaseProperty:GetChild("PropertyName"):SetText("Preview Sound")
   -- BaseProperty:GetChild("PropertyName")
    local button = Runtime.Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Icons/Engine/PauseAnPlay.png",
        Parent = FrameOption
    }
    
    button:SetImageRect(Rect.new(LineUp.play,Vector2.new(64,64)))

    button.Clicked:Connect(function()
        Thing:Play()
    end)
end

return Template