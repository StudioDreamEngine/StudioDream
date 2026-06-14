local Things = Runtime.Things

return function()
    return Things.Create("Square") {
        Size = Pivot2D.new(2,0,0,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline
    }
end