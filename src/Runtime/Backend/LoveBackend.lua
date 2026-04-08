-- Layer of abstraction on top of love2d in the case its needed
local Backend = {}

function Backend.CanvasCall(Canvas, DrawFunction)
    love.graphics.setCanvas(Canvas)
    love.graphics.push()
    love.graphics.origin() -- just in case

    DrawFunction()

    love.graphics.pop()
    love.graphics.setCanvas()
end

function Backend.NewImage(Path)
    return love.graphics.newImage(Path)
end

function Backend.GetMousePosition()
    local X, Y = love.mouse.getPosition()
    return Vector2.new(X, Y)
end

function Backend.SetColor(Color, Transparency)
    love.graphics.setColor(Color.R, Color.G, Color.B, Transparency)
end

function Backend.RenderCanvas(Canvas)
    love.graphics.draw(Canvas)
end

function Backend.NewCanvas(Size)
    return love.graphics.newCanvas(Size.X, Size.Y)
end

return Backend