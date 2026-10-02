-- We might let users create these later on, for now, only by devs
return function(Macros)
    Macros.MacroList = {
        ["Reload Resources"] = function()
            Runtime.Resources.ReloadResources()
        end,
        ["Redraw Explorer"] = function()
            Runtime.Things.RequestTreeChange()
        end,
        ["Export Project"] = function()
            Studio.Build.BuildProject()
        end,
        ["Load Scene"] = function()
            Platform.OpenWithCallback("Open Scene", Enum.OpenDialog.File, function(NewPath) -- Make this check attributes before actually setting thing resource (aka to limit stuff like an Audio thiing resource being set as a image ect ect@!!)
                local Identifier, _ = Runtime.Resources.LoadIdentifierIDFromPath(NewPath)
                if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end

                Runtime.Project.LoadEnviornment(Identifier)
            end)
        end,
        ["New Scene"] = function()
            local IdentifierID = Runtime.Resources.GetOrCreateIdentifierID("NewScene.sds")

            local Scene = Runtime.Things.CreateTemplate("Environment")
            Scene.Scene = IdentifierID

            Runtime.Project.Scenes.SaveScene(Scene)
        end
    }

    function Macros.Init()
        Studio.Components.CreateStyle("ListLayout",{
            Parent = Macros.Container
        })

        for Name, Macro in pairs(Macros.MacroList) do
            Studio.Components.CreateStyle("TextButton", {
                Size = Pivot2D.FromScale(1,0.1),
                Clicked = Macro,
                Text = Name,
                Parent = Macros.Container
            })
        end
    end

    return Macros
end