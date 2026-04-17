local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        CannotClear = true
    }

    ---@module "TextButton"
    local ButtonTest = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.15,0.15),
        Position = Pivot2D.FromScale(0,1),
        Pivot = Vector2.new(0,1),
        Parent = Viewport,
        Name = "ButtonTest"
    }
    
    ButtonTest.Clicked:Connect(function()
        print("Button Click")
        Things.ClearRoot()
    end)

    local MainViewport = Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.8),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        Name = "MainViewport"
    }

    local Mesh = Things.Create("Mesh") {
        Name = "Bleh"
    }

    local ScriptTest = Things.Create("Script") {
        Parent = Viewport,
        Name = "TestScript",
        ScriptContents = "while true do wait(1) print(\"Hello World\") end"
    }

    local Primitive = Things.Create("Primitive") {
        Name = "Baseplate"
    }

    Primitive.Position = Vector3.new(0, -1, 0)
    Primitive.Size = Vector3.new(512, 8, 512)

    --[[local ButtonTest = Things.Create("Folder") {
        Parent = Viewport,
        Name = "Folder Test!"
    }]]

    Mesh:SetParent(MainViewport)
    Primitive:SetParent(MainViewport)

    return { Viewport = Viewport }
end