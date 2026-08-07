local Decorations = require("Runtime.Backend.WindowManager.Decorations")
local WindowManager = {}

local Dimensions, WinFlags

function WindowManager.UpdateMode() love.window.setMode(Dimensions.X, Dimensions.Y, WinFlags) end

function WindowManager.SetSize(InDimensions)
    Dimensions = InDimensions
    WindowManager.UpdateMode()
end

function WindowManager.GetPosition()
    return Vector2.new(WinFlags.x, WinFlags.y)
end

---@param Position Vector2
function WindowManager.SetPosition(Position)
    WinFlags.x = Position.X
    WinFlags.y = Position.Y

    WindowManager.UpdateMode()
end

function WindowManager.SetBorderless(Borderless)
    WinFlags.borderless = Borderless
    WindowManager.UpdateMode()
end

function WindowManager.Init()
    local _Width, _Height
    _Width, _Height, WinFlags = love.window.getMode()
    Dimensions = Vector2.new(_Width, _Height)

    WindowManager.SetBorderless(true)
    Decorations.Init()
end

WindowManager.CreateTitleBar = Decorations.CreateTitleBar

function WindowManager.SetWindowTheme(Primary, Text)
    
end

function WindowManager.Update(dt)
    Decorations.Update(dt)
end

return WindowManager