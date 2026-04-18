local UI = {}

function UI.Init(Viewport)
    local Things = Runtime.Things

    local ExplorerViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.25,0.8),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Parent = Viewport,
        Name = "ExplorerViewport"
    }

    require("Editor.UI.ExplorerRender")(Things.Root, ExplorerViewport)
    require("Editor.UI.TopBar")(Viewport, ExplorerViewport)
    --require("Editor.UI.PropertiesRender")(Viewport, ExplorerViewport)
end

return UI