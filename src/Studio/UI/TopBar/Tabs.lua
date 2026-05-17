return {
    General = {
        {
            Component = "ToolbarButton",
            Arguments = {
                Name = "Move",
                Icon = "MoveIcon",
                OnClick = function()
                    print("Move clicked")
                end
            }
        },
        {
            Component = "Seperator"
        },
        --[[{
            Component = "Insert"
        }]]
    }
}