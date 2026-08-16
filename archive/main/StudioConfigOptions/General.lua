local GenConfig = {}

GenConfig.DisplayName = "General Configs"

function GenConfig.Create(Parent)
    local Settings = Studio.Components.Settings.new({
        {
            Title = "Theme",
            Type = "Dropdown",
            ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                return Studio.Theme.CurrentName
            end,
            UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                Studio.Theme.ChangeTheme(Text)
            end,
            Choices = Studio.Theme.GetNames()
        }
    }, Parent)
end

return GenConfig