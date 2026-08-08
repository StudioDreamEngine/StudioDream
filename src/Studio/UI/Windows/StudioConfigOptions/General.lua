local Template = {}

Template.DisplayName = "General Configs"

local ProjectOptions = {
    [1] = {
        Name = "Current Theme",
        OptionType = "Input",
        FunctionWhenCreate = function(Main)
            -- Create the dropdown, when choose, make everything load again maybe? :think:
        end,
    },
}


function Template.Create(Parent)
    local CreateObject = {}

     Runtime.Project.LoadedProject:Connect(function()
        --print("PROJECT LOADED DUMB FUCK")
     end)

    function CreateObject.CreatePartBlock(Name,TypeOfOption,ParentS)
        local PartObj = {}

        PartObj.Base = Runtime.Things.Create("Square") {
            Size = Pivot2D.FromScale(1,0.1),
            Parent =  CreateObject.Scroll,
            BackgroundTransparency = 1,
            --BackgroundColor = Studio.CurrentTheme.Outline,
            CornerRadius = 2,
        }

        PartObj.Text = Studio.Components.CreateStyle("Text", {
            Size = Pivot2D.FromScale(1,.5),
            Position = Pivot2D.FromScale(1,.5),
            Pivot = Vector2.new(1,.5),
            Parent = PartObj.Base,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.CurrentTheme.Text,
            Text = Name
        })

        PartObj.Option = Runtime.Things.Create("Text"..(TypeOfOption or "")) {
            Size = Pivot2D.FromScale(0.49,.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0,0.5),
            BackgroundColor = Studio.CurrentTheme.Outline,
            ForegroundColor = Studio.CurrentTheme.Text,
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