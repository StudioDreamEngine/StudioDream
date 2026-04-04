local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    local Viewport = Things.New("Viewport2D")
    Viewport.Name = "INTERNAL_Viewport"
    Viewport.ExplorerVisible = false

    return { Viewport = Viewport }
end