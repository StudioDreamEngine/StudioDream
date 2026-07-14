return {
    { 
        Component = "Image"
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "Project",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "Load Project",
                    Function = Studio.ProjectManager.LoadProject
                },
                {
                    Type = "Button",
                    Text = "Save Project",
                    Function = Studio.ProjectManager.SaveProject
                },
                {
                    Type = "Button",
                    Text = "Save Project To",
                    Function = Studio.ProjectManager.SaveProjectTo
                },
                {
                    Type = "Separator",
                },
                {
                    Type = "Button",
                    Text = "Configuration of the Project",
                    Function = function()
                        Studio.Editor3D.ToggleWindowOutside("PConfig",true)
                    end
                }
            }
        }
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "Configuration",
        }
    },
    { -- Tools
        Component = "Button",
        Arguments = {
            Name = "Help",
        }
    },
    {
        Component = "Button",
        Arguments = {
            Name = "Testing",
            Type = "Dropdown",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "Play",
                    SubResource = "Assets/Icons/Client.png",
                    Function = function(T)
                        Runtime.Project.Save()
                        Runtime.RequestRestart("Client")
                    end
                },

            }
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