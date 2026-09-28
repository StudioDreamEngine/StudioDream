local Things = Runtime.Things
local Components = Studio.Components

return function(Dialogs)
    function Dialogs.Init()
        Dialogs.CurrentlyUsing = nil
        Dialogs.Types = Utils.LoadModules("Studio/UI/Windows/CustomDialogs/", true)
        
    end

    function Dialogs.CreateDialog(Name,Info)
        Dialogs.FullContainer:SetVisible(true)
        if Dialogs.CurrentlyUsing then
            Dialogs.CurrentlyUsing:Destroy()
        end
        local Dialog = Dialogs.Types[Name]
        local DialogObject = Dialog.Init(Dialogs.Container,Info,Dialogs.FullContainer)

        DialogObject:Init()

        Dialogs.CurrentlyUsing = DialogObject
    end

    function Dialogs.Update(dt)
        
    end

    return Dialogs
end