local Template = {}

Template.DisplayName = "Example!!"

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
        CreateObject.WipWow:SetVisible(Visibly)
    end

    return CreateObject
end

return Template