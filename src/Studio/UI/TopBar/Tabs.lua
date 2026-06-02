return {
    Hud = {
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
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Move",
                Icon = "MoveIcon",
                OnClick = function()
                    print("Move clicked")
                end
            }
        },
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Scale",
                Icon = "ScaleIcon",
                OnClick = function()
                    print("Scale clicked")
                end
            }
        },
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Rotate",
                Icon = "RotIcon",
                OnClick = function()
                    print("Rotate clicked")
                end
            }
        },
        {
            Component = "Seperator"
        }, 
        -- Make here Tools config, like move tool grid, rotate config ect ect
        --{
        --    Component = "Seperator"
        --}, -- Insert/Studio stuff
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Insert Thing",
                Icon = "InsertIcon",
                OnClick = function()
                    Studio.Editor3D.OpenInsertWindow()
                end
            }
        },
        --[[{
            Component = "Insert"
        }]]
    },
}