local Info = {
    ["Testing"] = {
        Lock = false,
        Dropdown = nil
    }
}

return {
    { 
        Component = "Image",
        Arguments = {
            OnClick = function()
                print("Move clicked")
            end
        }
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "Project",
            OnClick = function()
                print("Move clicked")
            end
        }
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "Configuration",
            OnClick = function()
                print("Move clicked")
            end
        }
    },
    { -- Tools
        Component = "Button",
        Arguments = {
            Name = "Help",
            OnClick = function()
                love.system.openURL("https://deltarune.com/lancer/")
            end
        }
    },
    {
        Component = "Button",
        Arguments = {
            Name = "Testing",
            OnClick = function(Button)
                print(Button)
                Info.Testing.Locks = not Info.Testing.Locks
                if Info.Testing.Locks then
                    Info.Testing.Dropdown = Studio.Components.CreateDropdown(Button,{
                    {
                        Type = "Button",
                        Text = "Play",
                        SubImage = "Assets/Icons/Client.png",
                        Function = function(TheTabButton)
                            Info.Testing.Locks = false
                            Info.Testing.Dropdown:Remove()

                            ---@class Environment
                            local Environment = Runtime.Things.Root:GetEnvironment()

                            Environment.StepPhysics = true
                        end
                    },
                    {
                        Type = "Button",
                        Text = "Stop",
                        Function = function(TheTabButton)
                            Info.Testing.Locks = false
                            Info.Testing.Dropdown:Remove()

                            ---@class Environment
                            local Environment = Runtime.Things.Root:GetEnvironment()

                            Environment.StepPhysics = false
                        end
                    },
                })
                else
                    Info.Testing.Dropdown:Remove()
                end
            end
        }
    },
    {
        Component = "Button",
        Arguments = {
            Name = "Plugins (Soon)",
            OnClick = function()
                print("Move clicked")
            end
        }
    },
}