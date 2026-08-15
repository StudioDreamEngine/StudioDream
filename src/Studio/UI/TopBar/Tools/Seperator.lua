local Things = Runtime.Things

return function()
    return Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.new(0,2,1,0),
        BackgroundColor = "Outline"
    })
end