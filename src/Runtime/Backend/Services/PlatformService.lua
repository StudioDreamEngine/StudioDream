local PlatformService = {}

local Dimensions, WinFlags

function PlatformService.UpdateMode() love.window.setMode(Dimensions.X, Dimensions.Y, WinFlags) end

function PlatformService.SetSize(InDimensions)
    Dimensions = InDimensions
    PlatformService.UpdateMode()
end

function PlatformService.GetPosition()
    return Vector2.new(WinFlags.x, WinFlags.y)
end

---@param Position Vector2
function PlatformService.SetPosition(Position)
    WinFlags.x = Position.X
    WinFlags.y = Position.Y

    PlatformService.UpdateMode()
end

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

function PlatformService.ChangeTitle(NewTitle)
    love.window.setTitle(NewTitle) 
end

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

function PlatformService.OpenURL(Link)
    love.system.openURL(Link)
end

function PlatformService.GetExecutablePath()
    if love.filesystem.isFused() then
        return love.filesystem.getSource()
    else
        assert("You can only use GetProjectPath using a compiled version of StudioDream.")
    end
end

function PlatformService.IsFused()
    return FLAGS.Independent
end

return PlatformService