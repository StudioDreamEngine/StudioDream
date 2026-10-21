local Locks = {
    ["Insert"] = false
}

return {
    Hud = {
        Order = 2,
        {
            Component = "Seperator",
        },
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Hide Toolbar",
                Icon = "EyeOpen",
                OnClick = function(Button)
                    Button.ClickBool = not Button.ClickBool
                    Button.Text:SetText(Button.ClickBool and "UnHide Toolbar" or "Hide Toolbar")
                    Button.Image:SetResource("Internal/Studio/TabIcons/".. (Button.ClickBool and "EyeClose" or "EyeOpen") ..".png")

                    Studio.Layout.ToggleWindow(Studio.Layout.GetHandle("Windows.Toolbar"),not Button.ClickBool)
                end,
            }
        },
        {
            Component = "Seperator",
        },
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Insert Thing",
                Icon = "InsertIcon",
                OnClick = function()
                    Studio.EditorUI.ToggleWindow("InsertObject")
                    Studio.EditorUI.MoveWindowToMouse("InsertObject")
                end
            }
        },
        {
            Component = "Seperator",
        },
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
                Icon = "Play",
                OnClick = Studio.ProjectManager.RunStudioProject
            }
        },
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Stop Project",
                Icon = "Pause",
                OnClick = Studio.ProjectManager.StopStudioProject
            }
        },
        {
            Component = "Seperator",
        },
    },
}