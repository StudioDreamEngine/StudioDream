-- used for getting and changing general information about the operating system and window
---@class PlatformService
local PlatformService = {}

local Dimensions, WinFlags

-- Internal function to update the window state
function PlatformService.UpdateMode() love.window.setMode(Dimensions.X, Dimensions.Y, WinFlags) end

-- Set the size of the window.
function PlatformService.SetSize(InDimensions)
    Dimensions = InDimensions
    PlatformService.UpdateMode()
end

-- Get the position of the window on screen.
function PlatformService.GetPosition()
    return Vector2.new(WinFlags.x, WinFlags.y)
end

-- Set the position of the window on screen.
---@param Position Vector2
function PlatformService.SetPosition(Position)
    WinFlags.x = Position.X
    WinFlags.y = Position.Y

    PlatformService.UpdateMode()
end

function PlatformService.SetFlag(Flag, Value)
    WinFlags[Flag] = Value
    PlatformService.UpdateMode()
end

function PlatformService.GetFullscreen()
    return love.window.getFullscreen()
end

-- Change the title of the window (This should not existm you should only be able to change project name)
function PlatformService.ChangeTitle(NewTitle)
    love.window.setTitle(NewTitle) 
end

-- Change the windwowe icon
function PlatformService.ChangeIcon(Resource)
    local ToImageData = Utils.TextureToImageData(Resource)
    love.window.setIcon(ToImageData)
end

function PlatformService.Init()
    local _Width, _Height
    _Width, _Height, WinFlags = love.window.getMode()
    Dimensions = Vector2.new(_Width, _Height)
end

-- Open a link in a browser
function PlatformService.OpenURL(Link)
    love.system.openURL(Link)
end

-- Return where the executable path for the current project is, cannot be used in development mode
function PlatformService.GetExecutablePath()
    if love.filesystem.isFused() then
        return love.filesystem.getSource()
    else
        assert("You can only use GetProjectPath using a compiled version of StudioDream.")
    end
end

-- Returns If the project has been built
function PlatformService.IsFused()
    return FLAGS.Independent
end

return PlatformService