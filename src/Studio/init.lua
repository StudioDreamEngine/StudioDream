-- Only named StudioMain cuz init.lua is taken by the main script for stepping this version of the client... MIKL...
-- Why yall blaming me vro!!!
Studio = {}

function Studio.Init()
    Studio.Theme = require("Studio.Theme")
    Studio.EditorUI = require("Studio.EditorUI")
    Studio.CurrentTheme = Studio.Theme.GetThemes()[Runtime.SettingsManager.GetSetting("UsingTheme")] or Studio.Theme.CurrentTheme
    Studio.Editor3D = require("Studio.Editor3D")

    Studio.Layout = require("Studio.UI.StudioLayout")
    Studio.Components = require("Studio.UI.Components")

    Studio.Build = require("Studio.Build")

    Studio.ProjectManager = require("Studio.ProjectManager")

    Studio.Backend = require("Studio.Backend")
    
    Studio.EditorServices = Studio.Backend -- Mikl api backwards compat, remove later!

    Studio.Components.Init()
    Studio.Layout.CreateLayout()

    Studio.Editor3D.Init()
    Studio.Backend.Init()

    Runtime.SaveOnCrash = true

    --[[Scheduler.DelayTask(3, function()
        Studio.Components.CreateDialog("Option", {
            Text = "Your free trial of STUDIODREAM has expired.",
            Choices = {
                {
                    Text = "Renew ($199)",
                    OnClick = function()
                        
                    end
                },
                {
                    Text = "Quit",
                    OnClick = function()
                        love.event.quit()
                    end
                },
            }
        })
    end)]]

    printVerbose("Finished Initalizing studio")
    Shared.ProcessQueue()
end

function Studio.Update(dt)
    Studio.Editor3D.Update(dt)
    Studio.Layout.Update(dt)
    Studio.Components.Update(dt)

    -- improve this some other time -sonickirb :3
    Studio.PresenceService.State    = "Editing"
    Studio.PresenceService.Details  = Runtime.Project.Config.Get("Name") or "fucked up :3"
end

return Studio