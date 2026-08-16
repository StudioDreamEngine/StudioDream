local GenConfig = {}

GenConfig.DisplayName = "Volume Configs"

function GenConfig.Create(Parent)
    local CreateObject = {}

    function CreateObject.Create()
        CreateObject.Scroll = Studio.Components.CreateStyle("Slider",{
            Size = Pivot2D.FromScale(1,0.3),
            Parent = Parent,
        })
    end

    CreateObject.Create()

    function CreateObject.Toggle(Visibly)
        CreateObject.Scroll:SetVisible(Visibly)
    end

    return CreateObject
end

return GenConfig