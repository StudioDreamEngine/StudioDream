local FilePathd = {}
local Resources = Runtime.Resources

function FilePathd.Start(FrameOption,Thing,Property)

    local Attributes = Thing.Proxy.Attributes[Property] -- make attributes here do something like "only accept images/sounds/scenes" ect
    --print(Thing[Property])
    local MainText = Runtime.Things.Create("TextButton") {
        Text = Thing[Property] and Thing[Property].FileName or "No resource found.",
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        TextScaled = true,
        CornerRadius=5
    }
    
    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(1,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Icons/Engine/InsertResource.png",
        Parent = MainText
    }

    MainText.Clicked:Connect(function()
        Platform.OpenWithCallback("Select the resource for this property.", Enum.OpenDialog.File, function(NewPath)
            local Identifier, _ = Resources.LoadIdentifierIDFromPath(NewPath)
            if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","error") return end
            
            local PathObj = Path.new(NewPath,Identifier)
            --print(PathObj)
            Thing:SetResource(Identifier)
            MainText:SetText(PathObj.FileName)
        end)
    end)
end

return FilePathd