local Things = Runtime.Things
local Components = {}

function Components.CreateButton(Name, Properties)
    Properties.Text = Name
    Properties.CornerRadius = 7
    Properties.Align = Vector2.one * .5

    ---@class TextButton
    local Button = Components.CreateStyle("TextButton", Properties)
    --Button.Clicked:Connect(Function)

    return Button
end

function Components.CreateStyle(Type, Properties)
    Properties.BackgroundColor = Studio.Theme.Secondary
    Properties.ForegroundColor = Studio.Theme.Text
    Properties.OutlineSize = 2
    Properties.OutlineColor = Studio.Theme.SecondaryOutline

    return Things.Create(Type) (Properties)
end

return Components