local OutsideService = {}

function OutsideService.GetWindowSettings()
    local width, height, flags = love.window.getMode()
    return Vector2.new(width,height), flags
end

function OutsideService.GetTitle()
    return love.window.getTitle()
end

function OutsideService.ChangeTitle(NewTitle)
    love.window.setTitle(NewTitle) 
end

function OutsideService.ChangeIcon(Resource)
    local ToImageData = Utils.TextureToImageData(Resource)
    love.window.setIcon(ToImageData)
end

function OutsideService.SetWindowSettings(WindowVect,Flags)
    Utils.SetMode(WindowVect,Flags)
end

return OutsideService