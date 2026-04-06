local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.New("Viewport2D")
    Viewport.Name = "ViewportInternal"
    Viewport.Size = Pivot2D.FromOffset(Vector2.new(640, 480))

    local ImageTest2 = Things.New("Image2D")
    ImageTest2.ImageFile = "Assets/EditorIcons/16/add.png"
    ImageTest2.Name = "ImageTest2"
    ImageTest2.Position = Pivot2D.FromOffset(Vector2.new(300,50))
    ImageTest2:SetParent(Viewport)

    local Text = Things.New("Text")
    Text.Position = Pivot2D.FromOffset(Vector2.new(200,50))
    Text.Name = "TestText"
    Text:SetParent(Viewport)

    local Text2 = Things.New("Text")
    Text2.Position = Pivot2D.FromOffset(Vector2.new(200,50))
    Text2.Name = "TestInside"
    Text2:SetParent(Text)

    return { Viewport = Viewport }
end