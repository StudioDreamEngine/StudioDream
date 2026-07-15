local Template = {}

Template.DisplayName = "General Configs"

local ProjectOptions = {
    [1] = {
        Name = "Icon",
        OptionType = "Button",
        FunctionWhenCreate = function(Main)

            local Image = Runtime.Things.Create("Image2D") {
                Size = Pivot2D.FromScale(1,1),
                Pivot = Vector2.new(1,0),
                Position = Pivot2D.FromScale(1,0),
                SquareAxis = Enum.SquareAxis.Y,
                Resource = Runtime.Project.Config.Get("Icon") or "Internal/Icons/Client.png",
                Parent = Main.Option
            }

            function Draw()
                local IsIcon = Runtime.Project.Config.Get("Icon") and true or false
                local Result = Runtime.Project.Config.Get("Icon") or "Internal/Icons/Client.png"

                Image:SetResource(Result)
                Main.Option:SetText(IsIcon and Path.new(Result).FileName or Result)
            end
            
            Draw()

            Main.Option.Clicked:Connect(function()
                Identifier, _ = Resources.LoadIdentifierIDFromPath(NewPath)
                if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end

                Runtime.Project.Config.Set("Icon",PathObj.FilePath)
                Draw()
            end)
        end,
    }
}


function Template.Create(Parent)
    local CreateObject = {}

    function CreateObject.CreatePartBlock(Name,TypeOfOption,ParentS)
        local PartObj = {}

        PartObj.Base = Runtime.Things.Create("Square") {
            Size = Pivot2D.FromScale(1,0.1),
            Parent =  CreateObject.Scroll,
            BackgroundTransparency = 1,
            --BackgroundColor = Studio.Theme.CurrentTheme.Outline,
            CornerRadius = 2,
        }

        PartObj.Text = Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,1),
            Position = Pivot2D.FromScale(1,.5),
            Pivot = Vector2.new(1,.5),
            Parent = PartObj.Base,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.CurrentTheme.Text2,
            Text = Name
        }

        PartObj.Option = Runtime.Things.Create("Text"..(TypeOfOption or "")) {
            Size = Pivot2D.FromScale(0.49,.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0,0.5),
            BackgroundColor = Studio.Theme.CurrentTheme.Outline,
            ForegroundColor = Studio.Theme.CurrentTheme.Text2,
            Layer = 3,
            CornerRadius = 6,
            Parent = PartObj.Base,
        }

        return PartObj
    end

    function CreateObject.CreateOptions()
        for _,Option in pairs(ProjectOptions) do
            Option.FunctionWhenCreate(CreateObject.CreatePartBlock(Option.Name,Option.OptionType,CreateObject.Scroll))

        end
    end

    function CreateObject.Create()
        CreateObject.Scroll = Runtime.Things.Create("ScrollContainer") {
            Size = Pivot2D.FromScale(1,1),
            Parent = Parent,
            BackgroundTransparency = 1,
        }

        Runtime.Things.Create("ListLayout") {
            Parent = Scroll,
        }

        CreateObject.CreateOptions()
    end

    CreateObject.Create()

    function CreateObject.Toggle(Visibly)
        CreateObject.Scroll.Visible = Visibly
    end

    return CreateObject
end

return Template