local Components = Studio.Components
local Input = Runtime.Services.Service("InputService") ---@class InputService

local ProjectConfig = {}
ProjectConfig.Container = nil ---@class Square

function ProjectConfig.Init()
    Runtime.Project.LoadedProject:Connect(function()

    Components.Settings.new({
        General = {
            {
                Title = "Project Name",
                Type = "Input",
                ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                    return Runtime.Project.Config.Get("Name")
                end,
                UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                    Runtime.Project.EditName(Text)
                end,
            },
            {
                Title = "Project Icon",
                Type = "Button",
                UserRequest = function(Change)
                    Platform.OpenWithCallback("Select the resource for this property.", Enum.OpenDialog.File, function(NewPath) -- Make this check attributes before actually setting thing resource (aka to limit stuff like an Audio thiing resource being set as a image ect ect@!!)
                        local Identifier, _ = Runtime.Resources.LoadIdentifierIDFromPath(NewPath)
                        if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end

                        Change(Identifier)
                    end)
                end,
                UserChange = function(InfoGiven)
                    Runtime.Project.Config.Set("Icon",Identifier)
                end,
                ReturnDisplay = function()
                    return Runtime.Project.Config.Get("Icon") and Runtime.Resources.GetIdentifierFromID(Runtime.Project.Config.Get("Icon")).Data.FileName or "Internal/Icons/Client.png"
                end,
            },
            {
                Title = "Project Window Size",
                Type = "Input",
                Translate = "Vector2",
                UserChange = function(InfoGiven)
                    Runtime.Project.Config.Set("WindowSize",tostring(InfoGiven))
                end,
                ReturnDisplay = function()
                    print(Runtime.Project.Config.Get("WindowSize"))
                    if Runtime.Project.Config.Get("WindowSize") then
                        Decide = Vector2.FromString(Runtime.Project.Config.Get("WindowSize"))
                    else
                        Decide = Vector2.new(700,500)
                    end
                    print(Decide)
                    return Decide
                end
            },
            {
                Title = "Project Resizeable",
                Type = "Checkbox",
                UserChange = function(InfoGiven)
                    local Display
                    if Runtime.Project.Config.Get("WindowResize") then
                        Display = Runtime.Project.Config.Get("WindowResize")
                    else
                        Display = false
                    end
                    Runtime.Project.Config.Set("WindowResize", (not Display))
                end,
                ReturnDisplay = function()
                    local Display
                    if Runtime.Project.Config.Get("WindowResize") then
                        Display = Runtime.Project.Config.Get("WindowResize")
                    else
                        Display = false
                    end
                    return Display
                end
            },
            
        },
    }, ProjectConfig)

    end)
end

function ProjectConfig.Update(dt)
    
end

return ProjectConfig