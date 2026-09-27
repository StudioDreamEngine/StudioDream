local Input = {}

function Input.Init(Parented,Info)
    local DialogObject = {}

    function DialogObject:Create()
        self.Objects.Text = Studio.Components.CreateStyle("Text", {
            Size =  Pivot2D.FromScale(1,0.35),
            Position = Pivot2D.FromScale(0.5,0),
            Pivot = Vector2.new(0.5,0),
            Text = Info.Topic,
            Parent = Parented,
            ForegroundColor = "Text",
            Alignment = Enum.Alignment.TopCenter
        })

        self.Objects.Input = Studio.Components.CreateStyle("TextInput", {
            Size = Pivot2D.FromScale(0.95,0.2),
            Position = Pivot2D.FromScale(0.5,0.96),
            Pivot = Vector2.new(0.5,1),
            Placeholder = Info.Placeholder or "...",
            Parent = Parented,
            ForegroundColor = "Text",
            BackgroundTransparency = 0,
            BackgroundColor = "Outline",
            CornerRadius = 5,
            Alignment = Enum.Alignment.TopCenter
        })

        if Info.ApplyButton then
            self.Objects.Input:SetPosition(Pivot2D.FromScale(0.5,0.85))

            self.Objects.ApplyButton = Studio.Components.CreateButtonStyle({
                Size = Pivot2D.FromScale(0.3,0.1),
                Parent = Parented,
                Text = Info.ApplyButton,
                Pivot = Vector2.new(0.5,1),
                Position = Pivot2D.FromScale(0.5,1)
            })
            self.Objects.ApplyButton.Clicked:Connect(function()
                Info.OnEnd(self)
            end)
        else
            self.Objects.Input.FocusEnd:Connect(function(IsEnter)
                if Info.FilterEnter and IsEnter then
                    Info.OnEnd(self)
                else
                    Info.OnEnd(self)
                end
            end)
        end
    end

    function DialogObject:Init()
        self.Objects = {}

        self:Create()
    end

    function DialogObject:Destroy()
        for i,v in pairs(self.Objects) do
            v:Destroy()
        end

        table.clear(self.Objects)
        table.clear(DialogObject)
    end

    return DialogObject
end

return Input