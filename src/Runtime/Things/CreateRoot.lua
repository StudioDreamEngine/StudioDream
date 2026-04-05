local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.New("Viewport2D")
    Viewport.Name = "INTERNAL_Viewport"
    Viewport.ExplorerVisible = false
    Viewport.Size = Pivot2D.FromOffset(Vector2.new(640, 480))

    local ImageTest = Things.New("Image2D")
    ImageTest.ImageFile = "Editor/Assets/Icons/16/application_edit.png"
    ImageTest.Size = Pivot2D.FromOffset(Vector2.new(100,100))
    ImageTest.Position = Pivot2D.FromOffset(Vector2.new(40,40))
    ImageTest:SetParent(Viewport)

    return { Viewport = Viewport }
end