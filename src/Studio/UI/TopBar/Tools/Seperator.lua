local Things = Runtime.Things

return function()
    return Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.new(2,0,0,1),
        BackgroundColor = "Outline"
    })
end