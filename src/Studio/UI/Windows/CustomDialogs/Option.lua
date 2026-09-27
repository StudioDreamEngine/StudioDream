local Option = {}

function Option.Init(Parented,Info)
    local DialogObject = {}

    function DialogObject:Create()
        local function CreateButton(Name,Function)
            self.Objects[Name] = Studio.Components.CreateButtonStyle({
                Size = Pivot2D.FromScale(0.3,0.8),
                Parent = self.Objects.Organizer,
                Text = Name,
                Pivot = Vector2.new(0,0),
                Position = Pivot2D.FromScale(0,0.5)
            })
            self.Objects[Name].Clicked:Connect(function()
                Function(self)
            end)
        end

        self.Objects.Text = Studio.Components.CreateStyle("Text", {
            Size =  Pivot2D.FromScale(1,0.35),
            Position = Pivot2D.FromScale(0.5,0),
            Pivot = Vector2.new(0.5,0),
            Text = Info.Topic,
            Parent = Parented,
            ForegroundColor = "Text",
            Alignment = Enum.Alignment.TopCenter
        })

        self.Objects.Organizer = Studio.Components.CreateStyle("Square", {
            Size =  Pivot2D.FromScale(1,0.25),
            Position = Pivot2D.FromScale(0.5,1),
            Pivot = Vector2.new(0.5,1),
            Parent = Parented,
            BackgroundTransparency = 1,
            Alignment = Enum.Alignment.TopCenter
        })

        self.Objects.List = Studio.Components.CreateStyle("ListLayout", {
            Parent = self.Objects.Organizer,
            Padding = 4,
            Direction = Enum.LayoutDirection.Horizontal,
            Alignment = Enum.Alignment.Center,
        })

        for Name,Function in pairs(Info.Choices) do
            CreateButton(Name,Function)
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

return Option