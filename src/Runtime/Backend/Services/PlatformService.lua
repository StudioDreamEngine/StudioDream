local PlatformService = {}

function PlatformService.Init()

end

function PlatformService.GetWindowSettings()
    local width, height, flags = love.window.getMode()
    return Vector2.new(width,height), flags
end

function PlatformService.GetTitle()
    return love.window.getTitle()
end

function PlatformService.ChangeTitle(NewTitle)
    love.window.setTitle(NewTitle) 
end

function PlatformService.ChangeIcon(Resource)
    local ToImageData = Utils.TextureToImageData(Resource)
    love.window.setIcon(ToImageData)
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