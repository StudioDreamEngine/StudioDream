local Components = Studio.Components
local Input = Runtime.Services.Service("InputService") ---@class InputService

local Config = Runtime.Project.Config

return function(ProjectConfig)
    local ViewportWindow = Studio.Layout.GetHandle("Viewport")

    function ProjectConfig.Init()
        Components.Settings.new({
            General = {
                {
                    Title = "Project Name",
                    Type = "Input",
                    ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                        return Config.Get("Name")
                    end,
                    UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                        Runtime.Project.EditName(Text)
                    end,
                },
                { -- TODO: Improve
                    Title = "Project Icon",
                    Type = "Button",
                    UserRequest = function(Change)
                        Studio.Components.OpenResourcePicker(Change)
                    end,
                    UserChange = function(InfoGiven)
                        Config.Set("Icon",Identifier)
                    end,
                    ReturnDisplay = function()
                        return Config.Get("Icon") and Runtime.Resources.GetIdentifierFromID(Config.Get("Icon")).Data.FileStem or "Internal/Icons/Client.png"
                    end,
                },
                {
                    Title = "Initial Scene",
                    Type = "Button",
                    UserRequest = function(Change)
                        Studio.Components.OpenResourcePicker(Change)
                    end,
                    UserChange = function(InfoGiven)
                        Config.Set("MainScene", InfoGiven)
                        ViewportWindow.CreateDefaultScene()
                    end,
                    ReturnDisplay = function()
                        local MainScene = Config.Get("MainScene")
                        return MainScene and Runtime.Resources.GetIdentifierFromID(MainScene).Data.FileStem or "No Scene Selected."
                    end,
                }
            },
            Window = {
                {
                    Title = "Window Size",
                    Type = "Input",
                    Translate = "Vector2",
                    UserChange = function(InfoGiven)
                        Config.Set("WindowSize",InfoGiven)
                    end,
                    ReturnDisplay = function()
                        return Vector2.FromString(Config.Get("WindowSize"))
                    end
                },
                {
                    Title = "Is Window Resizable",
                    Type = "Checkbox",
                    UserChange = function(InfoGiven)
                        local Display = Config.Get("WindowResizable")
                        Config.Set("WindowResizable", (not Display))
                    end,
                    ReturnDisplay = function()
                        return Config.Get("WindowResizable")
                    end
                },
            }
        }, ProjectConfig)
    end

    function ProjectConfig.Update(dt)
        
    end

    return ProjectConfig
end