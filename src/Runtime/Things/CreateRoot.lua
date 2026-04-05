local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.New("Viewport2D")
    Viewport.Name = "INTERNAL_Viewport"
    Viewport.ExplorerVisible = false
    Viewport.Size = Pivot2D.FromOffset(Vector2.new(640, 480))

    local SquareTest = Things.New("SquarePrimative")
    SquareTest.Size = Pivot2D.FromOffset(Vector2.new(200,200))
    SquareTest:SetParent(Viewport)

    return { Viewport = Viewport }
end