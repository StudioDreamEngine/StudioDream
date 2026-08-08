local Locks = {
    ["Insert"] = false
}

return {
    Hud = {
        Order = 2,
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "WIP!",
                Icon = "InsertIcon",
                OnClick = function()
                    
                end
            }
        },
    },
    Plugins = {
        Order = 3,
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "WIP!",
                Icon = "RotIcon",
                OnClick = function()
                    
                end
            }
        },
    },
    General = {
        Order = 1,
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "WIP!",
                Icon = "RotIcon",
                OnClick = function()
                    
                end
            }
        },
    },
}