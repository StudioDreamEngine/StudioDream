-- Layer of abstraction on top of love2d in the case its needed
local Backend = {}

local ShaderFolder = "Assets/Shaders/"
Backend.InterfaceShader = love.graphics.newShader(ShaderFolder.."Interface.glsl")

local StencilCandidates = {
    "stencil8",
    "depth24stencil8",
    "depth32fstencil8"
}
local StencilFormat

Backend.UnsupportedHardware = false

-- idk what to name this
function Backend.ManageCompat()
    local CanvasFormats = love.graphics.getTextureFormats({ canvas=true })

    for _, Candidate in pairs(StencilCandidates) do
        if CanvasFormats[Candidate] then
            StencilFormat = Candidate
            break
        end
    end

    if StencilFormat then
        print("Using stencil format "..StencilFormat)
    else
        warn("No supported stencil format found, Certain visual features will be missing")
        Backend.UnsupportedHardware = true
    end
end

function Backend.CanvasCall(Canvas, DrawFunction)
    local OldCanvas = love.graphics.getCanvas()

    if FLAGS.DebugDraw then
        DrawFunction()
        return
    end
    
    love.graphics.setCanvas(Canvas)
    love.graphics.clear()

    love.graphics.push()
    love.graphics.origin() -- just in case

    DrawFunction()

    love.graphics.pop()
    love.graphics.setCanvas(OldCanvas)
end

function Backend.ShaderCall(DrawFunction, Shader)
    love.graphics.setShader(Shader)
    DrawFunction(Shader)
    love.graphics.setShader()
end

function Backend.GetMouseDown(Button)
    return love.mouse.isDown(Button or 1)
end

function Backend.SetMousePosition(Position)
    love.mouse.setPosition(Position.X, Position.Y)
end

function Backend.DebugLabel(Position, String)
    if FLAGS.DebugDraw then
        love.graphics.push("all")

        love.graphics.circle("fill", Position.X, Position.Y, 5)
        love.graphics.setFont(DebugFont)
        love.graphics.print(String, Position.X, Position.Y)

        love.graphics.pop()
    end
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

function Backend.NewCanvas(Size, Stencil)
    local StencilCanvas = (Stencil and StencilFormat) and love.graphics.newCanvas(Size.X, Size.Y, { format = StencilFormat })

    return love.graphics.newCanvas(Size.X, Size.Y), StencilCanvas
end

function Backend.NewQuad(Rect, ImageSize)
    if Rect.Type == "Vector2" then
        return love.graphics.newQuad(0,0, Rect.X, Rect.Y, ImageSize.X, ImageSize.Y)
    else
        return love.graphics.newQuad(Rect.Origin.X, Rect.Origin.Y, Rect.Size.X, Rect.Size.Y, ImageSize.X, ImageSize.Y)
    end
end

Backend.SetMouseVisible = love.mouse.setVisible
Backend.KeyDown = love.keyboard.isDown
Backend.NewImage = love.graphics.newImage
Backend.RenderCanvas = love.graphics.draw

return Backend