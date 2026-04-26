local Backend3D = {}
local DreamWorld

function Backend3D.Init()
    ---@diagnostic disable-next-line: missing-parameter
    Dream:init()
    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDistortionMargin()

    DreamWorld = Dream:newObject()
end

function Backend3D.GetWorld()
    return DreamWorld
end

function Backend3D.LoadObject(Object, Path)
    local DreamObject = Dream:loadObject(Path)

    DreamWorld.objects[Object.UUID] = DreamObject
    return DreamObject
end

function Backend3D.RemoveObject(Object)
    DreamWorld.object[Object.UUID] = nil
end

return Backend3D