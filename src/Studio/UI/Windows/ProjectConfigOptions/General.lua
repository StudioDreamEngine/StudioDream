local Template = {}

Template.DisplayName = "General Configs"

local ProjectOptions = {
    [1] = {
        Name = "Project Name",
        OptionType = "Input",
        FunctionWhenCreate = function(Main)
            function Draw()
                Main.Option:SetText(Runtime.Project.Config.Get("Name"))
            end

            Runtime.Project.LoadedProject:Connect(Draw)

            Main.Option.FocusEnd:Connect(function()
                local DidWorked = Runtime.Project.EditName(Main.Option.Text)
                printVerbose(DidWorked)
            end)
        end,
    },
    [2] = {
        Name = "Icon",
        OptionType = "Button",
        FunctionWhenCreate = function(Main)
            function Draw()
                local Result = Runtime.Project.Config.Get("Icon") or "Internal/Icons/Client.png"
                Main.Option:SetText(IsIcon and Path.new(Result).FileName or Result)
            end
            
            Draw()

            Main.Option.Clicked:Connect(function()
                Platform.OpenWithCallback("Select the resource for the project icon.", Enum.OpenDialog.File, function(NewPath)
                    Identifier, _ = Runtime.Resources.LoadIdentifierIDFromPath(NewPath)
                    if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end
                    local PathObj = Path.new(NewPath,Identifier)
                    Runtime.Project.Config.Set("Icon",PathObj.FilePath)
                    Draw()
                end)
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
            Parent = CreateObject.Scroll,
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