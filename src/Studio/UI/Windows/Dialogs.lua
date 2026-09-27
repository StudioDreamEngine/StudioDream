local Things = Runtime.Things
local Components = Studio.Components

return function(Dialogs)
    function Dialogs.Init()
        Dialogs.CurrentlyUsing = nil
        Dialogs.Types = Utils.LoadModules("Studio/UI/Windows/CustomDialogs/", true)

        Dialogs.CreateDialog("Input",{
            Topic = "Brother!",
            Placeholder = "Weird!",
            ApplyButton = "Apply",
            OnEnd = function()
                print("Coil!")
            end,
        })
    end

    function Dialogs.CreateDialog(Name,Info)
        if Dialogs.CurrentlyUsing then
            Dialogs.CurrentlyUsing:Destroy()
        end
        local Dialog = Dialogs.Types[Name]
        local DialogObject = Dialog.Init(Dialogs.Container,Info)

        DialogObject:Init()

        Dialogs.CurrentlyUsing = DialogObject
    end

    function Dialogs.Update(dt)
        
    end

    return Dialogs
end