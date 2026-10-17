-- used for getting and changing general information about the operating system and window
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

-- Change if or if not the window doesnt have a border and title bar on it.
function PlatformService.SetBorderless(Borderless)
    WinFlags.borderless = Borderless
    PlatformService.UpdateMode()
end

function PlatformService.GetFullscreen()
    return love.window.getFullscreen()
end

function PlatformService.SetWindowFlags(Table)
    -- https://love2d.org/wiki/love.window.setMode
    if type(Table) == "table" then
        love.window.setMode(Dimensions.X, Dimensions.Y, Table) 
    else
        assert("Table expected, got "..type(Table)..", Visit: https://love2d.org/wiki/love.window.setMode on more info of SetWindowFlags works")
    end
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

function PlatformService.SetVSync(Number)
    -- https://love2d.org/wiki/love.window.setVSync
    if type(Number) == "number" then
        love.window.setMode(Dimensions.X, Dimensions.Y, Table) 
    else
        assert("Number expected, got "..type(Number)..", Visit: https://love2d.org/wiki/love.window.setVSync on more info of SetVSync works")
    end
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