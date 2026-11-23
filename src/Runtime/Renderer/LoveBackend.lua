-- General utility functions that wrap around Love2D
local Backend = {}

local ShaderFolder = "Assets/Shaders/"
Backend.InterfaceShader = love.graphics.newShader(ShaderFolder.."Interface.glsl")

local StencilCandidates = {
    "stencil8",
    "depth24stencil8",
    "depth32fstencil8"
}
local StencilFormat

local SupportedSystems = {
    "Linux",
    "Windows"
}

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

    if (not table.find(SupportedSystems, love.system.getOS())) then
        warn("Running on unsupported or untested operating system, stability may be impacted.")
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
        love.graphics.pushAll()

        love.graphics.circle("fill", Position.X, Position.Y, 5)
        love.graphics.setFont(DebugFont)
        love.graphics.print(String, Position.X, Position.Y)

        love.graphics.pop()
    end
end

function Backend.DebugPrint(Anchor, String)
    local Width, Height = love.graphics.getDimensions()

    if FLAGS.DebugDraw then
        love.graphics.pushAll()
        love.graphics.setFont(DebugFont)

        local NDC = (Anchor * 2) - Vector2.one
        local Pixel = Vector2.new(Width, Height) * Anchor

        love.graphics.print(String, Pixel.X - (Anchor.X * 200), Pixel.Y - (#string.split(String, "\n") * NDC.Y * 12))
        love.graphics.pop()
    end
end

function Backend.GetWindowSize(ScaleToDPI)
    local Size = Vector2.new(love.graphics.getWidth(), love.graphics.getHeight())

    if ScaleToDPI then
        return Size * love.window.getDPIScale()
    else
        return Size
    end
end

function Backend.GetMousePosition()
    local X, Y = love.mouse.getPosition()
    return Vector2.new(X, Y)
end

function Backend.SetColor(Color, Transparency)
    love.graphics.setColor(Color.R, Color.G, Color.B, Transparency or Color.A)
end

function Backend.NewCanvas(Size, Stencil, UseMSAA, UseBuffer)
    local StencilCanvas = (Stencil and StencilFormat) and love.graphics.newCanvas(Size.X, Size.Y, { format = StencilFormat, msaa = UseMSAA and 4 })

    return love.graphics.newCanvas(Size.X, Size.Y, {
        msaa = UseMSAA and 4
    }), (UseBuffer and love.graphics.newCanvas(Size.X, Size.Y) or nil), StencilCanvas
end

function Backend.GetCanvas()
    local Canvas = love.graphics.getCanvas()

    if type(Canvas) == "table" then
        if type(Canvas[1]) == "table" then -- why love2d
            return Canvas[1][1]
        end

        return Canvas[1]
    else
        return Canvas
    end
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