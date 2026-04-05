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

    local ImageTest = Things.New("Image2D")
    ImageTest.ImageFile = "Editor/Assets/Icons/16/application_edit.png"
    ImageTest.Size = Pivot2D.FromOffset(Vector2.new(100,100))
    ImageTest.Position = Pivot2D.FromOffset(Vector2.new(100,100))
    ImageTest:SetParent(Viewport)

    return { Viewport = Viewport }
end