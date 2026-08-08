local Template = {}

Template.DisplayName = "Keybinds"

function Template.Create(Parent)
    local CreateObject = {}

    function CreateObject.Create()
        CreateObject.WipWow = Studio.Components.CreateStyle("Text", {
            Size = Pivot2D.FromScale(1,1),
            Parent = Parent,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.CurrentTheme.Text,
            Text = "WIP"
        })
    end

    CreateObject.Create()

    function CreateObject.Toggle(Visibly)
        CreateObject.WipWow.Visible = Visibly
    end

    return CreateObject
end

return Template