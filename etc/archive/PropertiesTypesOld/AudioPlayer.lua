local Template = {}

Template.CustomConnect = "Playing"

local LineUp = {
        ["Play"] = Vector2.new(64,0),
        ["Stop"] = Vector2.new(0,0),
    }

Template.CustomName = "Preview Sound"

local button

function Template.Start(FrameOption,Thing,Property,BaseProperty) -- Scrapped for now
   -- BaseProperty:GetChild("PropertyName")
    button = Runtime.Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Icons/Engine/PauseAnPlay.png",
        Parent = FrameOption
    }
    
    button:SetImageRect(Rect.new(LineUp.Play,Vector2.new(64,64)))

    button.Clicked:Connect(function()
        if Thing.Resource then
            if Thing.Playing then
                Thing:Pause()
            else
                Thing:Play()
            end
            --button:SetImageRect(Rect.new(LineUp[Thing.Playing and "Play" or "Stop"],Vector2.new(64,64)))
        else
            Utils.SendNotification("Audio thing doesnt has a Resource to play","info")
        end
    end)
end

function Template.Update(DoesItStillPlay)
    button:SetImageRect(Rect.new(LineUp[DoesItStillPlay and "Stop" or "Play"],Vector2.new(64,64)))
end 

function Template.WhenReset(Thing)
    Thing:Rewind()
    Thing:Stop()
end

return Template