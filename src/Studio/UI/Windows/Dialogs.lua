local Things = Runtime.Things
local Components = Studio.Components

return function(Dialogs)
    function Dialogs.Init()
        Dialogs.CurrentlyUsing = nil
        Dialogs.Types = Utils.LoadModules("Studio/UI/Windows/CustomDialogs/", true)
    end

    function Dialogs.CreateDialog(Name,Info)
        Studio.Layout.ToggleWindow(Dialogs, true)

        if Dialogs.CurrentlyUsing then
            Dialogs.CurrentlyUsing:Destroy()
        end

        local Dialog = Dialogs.Types[Name]
        local DialogObject = Dialog.Init(Dialogs.Container,Info or {},Dialogs.FullContainer)
        DialogObject:Init()

        Dialogs.CurrentlyUsing = DialogObject

        return DialogObject
    end

    function Dialogs.Update(dt)

    end

    return Dialogs
end