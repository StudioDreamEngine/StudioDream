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
    ImageTest.Position = Pivot2D.FromOffset(Vector2.new(50,50))
    ImageTest:SetParent(Viewport)

    local ImageTest2 = Things.New("Image2D")
    ImageTest2.ImageFile = "Editor/Assets/Icons/16/add.png"
    ImageTest2.Position = Pivot2D.FromOffset(Vector2.new(10,50))
    ImageTest2:SetParent(Viewport)

    Viewport:RenderThingies()

    return { Viewport = Viewport }
end