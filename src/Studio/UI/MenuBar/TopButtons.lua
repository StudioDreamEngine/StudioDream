return {
    { 
        Component = "Image"
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "File",
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
            }
        }
    },
    { 
        Component = "Button",
        Arguments = {
            Name = "Project",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "Project Settings",
                    Function = function()
                        Studio.Editor3D.ToggleWindowOutside("PConfig",true)
                    end
                },
                {
                    Type = "Separator",
                },
                {
                    Type = "Button",
                    Text = "Resolve Missing Resources",
                    Function = function()
                        
                    end
                }
            }
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
            Name = "Test",
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
}