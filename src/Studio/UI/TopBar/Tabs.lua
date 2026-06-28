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
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Move",
                Icon = "MoveIcon",
                OnClick = function()
                    Studio.Editor3D.ToolManager.ChangeTool("Move")
                end
            }
        },
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Scale",
                Icon = "ScaleIcon",
                OnClick = function()
                    Studio.Editor3D.ToolManager.ChangeTool("Scale")
                end
            }
        },
        { -- Tools
            Component = "ToolbarButton",
            Arguments = {
                Name = "Rotate",
                Icon = "RotIcon",
                OnClick = function()
                    Studio.Editor3D.ToolManager.ChangeTool("Rotate")
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
                    Locks.Insert = not Locks.Insert
                    if Locks.Insert then
                        Studio.Editor3D.OpenInsertWindow()
                    else
                        Studio.Editor3D.CloseInsertWindow()
                    end
                end
            }
        },
        --[[{
            Component = "Insert"
        }]]
    },
}