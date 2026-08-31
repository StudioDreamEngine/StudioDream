return {
    { 
        Component = "Image",
        Arguments = {
            Function = function()
                Studio.Editor3D.ToggleWindowOutside("Start",true)
            end,
        }
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
                {
                    Type = "Button",
                    Text = "Export Project (ZIP)",
                    Function = Studio.ProjectManager.PackageProject
                }
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
                        Studio.Editor3D.ToggleWindowOutside("ProjectConfig",true)
                    end
                },
                {
                    Type = "Button",
                    Text = "Resolve Missing Resources",
                    Function = function()
                        print("TODO")
                    end
                },
                {
                    Type = "Separator"
                },
                {
                    Type = "Button",
                    Text = "Test in client",
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
            Name = "Editor",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "Configuration",
                    Function = function()
                        Studio.Editor3D.ToggleWindowOutside("StudioConfig",true)
                    end
                },
                {
                    Type = "Button",
                    Text = "Quit",
                    Function = function()
                        love.event.quit()
                    end
                },
            }
        }
    },
    --[[{ 
        Component = "Button",
        Arguments = {
            Name = "DoNothing",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "DoesNothingButton",
                    Function = function()
                        
                    end
                },
            }
        }
    },]]
    {
        Component = "Button",
        Arguments = {
            Name = "Help",
            Type = "Dropdown",
            Dropdown = {
                {
                    Type = "Button",
                    Text = "Documentation",
                    Function = function(T)
                        local Outside = Runtime.Services.Service("PlatformService")
                        Outside.OpenURL("https://www.youtube.com/@StudioDreamEngine")
                    end
                },
                {
                    Type = "Button",
                    Text = "Discord",
                    Function = function(T)
                        local Outside = Runtime.Services.Service("PlatformService")
                        Outside.OpenURL("https://discord.com/invite/yyCa7ed77X")
                    end
                },
                {
                    Type = "Button",
                    Text = "Youtube",
                    Function = function(T)
                        local Outside = Runtime.Services.Service("PlatformService")
                        Outside.OpenURL("https://www.youtube.com/@StudioDreamEngine")
                    end
                },
                {
                    Type = "Separator"
                },
                {
                    Type = "Button",
                    Text = "About",
                    Function = function(T)
                        
                    end
                },
                {
                    Type = "Button",
                    Text = "Credits",
                    Function = function(T)
                        Studio.Editor3D.ToggleWindowOutside("Credits",true)
                    end
                },
            }
        }
    },
}