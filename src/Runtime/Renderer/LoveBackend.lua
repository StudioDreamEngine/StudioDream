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

function Backend.GetMouseDown(Button)
    return love.mouse.isDown(Button or 1)
end

function Backend.SetMousePosition(Position)
    love.mouse.setPosition(Position.X, Position.Y)
end

function Backend.GetWindowSize()
    return Vector2.new(love.graphics.getWidth(), love.graphics.getHeight())
end

function Backend.GetMousePosition()
    local X, Y = love.mouse.getPosition()
    return Vector2.new(X, Y)
end

function Backend.SetColor(Color, Transparency)
    love.graphics.setColor(Color.R, Color.G, Color.B, Transparency)
end

function Backend.NewCanvas(Size)
    return love.graphics.newCanvas(Size.X, Size.Y)
end

function Backend.NewQuad(Rect, ImageSize)
    return love.graphics.newQuad(Rect.Min.X, Rect.Min.Y, Rect.Max.X-Rect.Min.X, Rect.Max.Y-Rect.Min.Y, ImageSize.X, ImageSize.Y)
end

Backend.SetMouseVisible = love.mouse.setVisible
Backend.KeyDown = love.keyboard.isDown
Backend.NewImage = love.graphics.newImage
Backend.RenderCanvas = love.graphics.draw

return Backend