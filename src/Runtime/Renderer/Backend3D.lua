---@diagnostic disable: inject-field
local Backend3D = {}
local DreamWorld

function Backend3D.Init()
    Dream:init() ---@diagnostic disable-line: missing-parameter

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDistortionMargin()

    DreamWorld = Dream:newObject()
    DreamWorld.name = "DreamWorld"
end

function Backend3D.GetWorld()
    return DreamWorld
end

--- Assign all DreamObjects the ClassReference object, instead of merging the object into one single mesh
--- @param Object DreamObject
--- @param ClassReference Drawable3D
local function AssignClassReference(Object, ClassReference)
    Object.ClassReference = ClassReference

    for _, ChildObject in pairs(Object.objects) do
        AssignClassReference(ChildObject, ClassReference)
    end
end

function Backend3D.LoadObject(Object, Path)
    local DreamObject = Dream:loadObject(Path)
    AssignClassReference(DreamObject, Object)

    DreamWorld.objects[Object.UUID] = DreamObject
    return DreamObject
end

function Backend3D.RemoveObject(Object)
    DreamWorld.objects[Object.UUID] = nil
end

return Backend3D