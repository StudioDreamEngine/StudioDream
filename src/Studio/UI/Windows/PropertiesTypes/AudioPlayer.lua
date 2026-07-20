local Template = {}

local LineUp = {
        ["Play"] = Vector2.new(64,0),
        ["Stop"] = Vector2.new(0,0),
    }

function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections

    for i,v in pairs(MainInfo.WillHandle) do
        -- Nothin, this is mostly for when the property will be set up
    end

    MainInfo.Option.BackgroundTransparency = 1
    MainInfo.Text:SetText("Preview Audio")

    local Button = Runtime.Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/PauseAnPlay.png",
        Parent = MainInfo.Option
    }
    
    Button:SetImageRect(Rect.new(LineUp.Play,Vector2.new(64,64)))

    function self.Update()
        for i,Info in pairs(MainInfo.WillHandle) do
            Button:SetImageRect(Rect.new(LineUp[Info.Thing.Playing and "Play" or "Stop"],Vector2.new(64,64)))
        end
    end

    table.insert(MainInfo.Connections,Button.Clicked:Connect(function()
        self.Update()
        for i,Info in pairs(MainInfo.WillHandle) do
            if Info.Thing.Playing then
                Info.Thing:Pause()
            else
                Info.Thing:Play()
            end
        end
    end))

    return self
end

return Template