local Locks = {
    ["Insert"] = false
}

return {
    Hud = {
        Order = 2,
    },
    Plugins = {
        Order = 3,
    },
    General = {
        Order = 1,
        {
            Component = "Seperator",
        },
        {
            Component = "ToolbarNumbers",
            Arguments = {
                Name = "Wow",
                OnClick = function()
                    
                end
            }
        },
        {
            Component = "Seperator",
        },
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Test Project (Studio)",
                Icon = "InsertIcon",
                OnClick = Studio.ProjectManager.RunStudioProject
            }
        },
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Stop Project",
                Icon = "InsertIcon",
                OnClick = Studio.ProjectManager.StopStudioProject
            }
        },
    },
}