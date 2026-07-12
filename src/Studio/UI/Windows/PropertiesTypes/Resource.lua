local Template = {}

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

local Resources = Runtime.Resources

function Template.Start(MainInfo)
    local self = {}

    local Button = Runtime.Things.Create("TextButton") {
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.CurrentTheme.FontBold,
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        CornerRadius = 5,
    }

    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(1,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/InsertResource.png",
        Parent = Button
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                Button:SetText(Info.Thing[Info.Property] and Info.Thing[Info.Property].FileName or "No resource found.")
            else
                Button:SetText("~")
            end
        end
    end
    self.Update()

    table.insert(MainInfo.Connections,Button.Clicked:Connect(function()
        local Identifier

        Platform.OpenWithCallback("Select the resource for this property.", Enum.OpenDialog.File, function(NewPath) -- Make this check attributes before actually setting thing resource (aka to limit stuff like an Audio thiing resource being set as a image ect ect@!!)
            Identifier, _ = Resources.LoadIdentifierIDFromPath(NewPath)
            if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end

            local PathObj = Path.new(NewPath)
            Button:SetText(PathObj.FileName)

            print(Identifier)

            for i,Info in pairs(MainInfo.WillHandle) do
                Runtime.Things.SetProperty(Info.Thing, Info.Property, Identifier)
            end
        end)
    end))

    return self
end

return Template