local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.Create "Viewport2D" {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(Vector2.new(800, 600))
    }

    local ImageTest2 = Things.Create "Image2D" {
        ImageFile = "Assets/EditorIcons/16/add.png",
        Name = "ImageTest2",
        Position = Pivot2D.FromOffset(Vector2.new(300,50))
    }
    ImageTest2:SetParent(Viewport)

  --  ImageTest2:RenderThingies(Vector2.new(16,16),Viewport)
    Viewport:RenderThingies()
    print(Viewport.Children)
    return { Viewport = Viewport }
end