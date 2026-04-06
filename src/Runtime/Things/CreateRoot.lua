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

    local Text = Things.Create "Text" {
        Position = Pivot2D.FromOffset(Vector2.new(200,50)),
        Name = "TestText"
    }
    Text:SetParent(Viewport)

    local Text2 = Things.Create "Text" {
        Position = Pivot2D.FromOffset(Vector2.new(200,50)),
        Name = "TestInside"
    }
    Text2:SetParent(Text)

    local TestScale = Things.Create "SquarePrimative" {
        Position = Pivot2D.FromScale(1,.5),
        Size = Pivot2D.new(0,.5,0,1),
        Pivot = Vector2.new(1,.5)
    }
    TestScale:SetParent(Viewport)

    return { Viewport = Viewport }
end