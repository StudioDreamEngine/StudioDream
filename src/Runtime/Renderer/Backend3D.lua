---@diagnostic disable: inject-field
local Backend3D = {}
local DreamWorld, DreamAdorns

function Backend3D.Init()
    Dream:init() ---@diagnostic disable-line: missing-parameter

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDistortionMargin()

    -- Stores the entire world, and the objects the runtime sees
    DreamWorld = Dream:newObject()
    DreamWorld.name = "DreamWorld"

    -- Stores Objects that are not nesscessarily part of the enviornment itself, instead intended to be visible only to the object using them and 3dreamengine
    DreamAdorns = Dream:newObject()
    DreamAdorns.name = "DreamAdorns"
end

function Backend3D.GetWorld()
    return DreamWorld
end

function Backend3D.GetAdorns()
    return DreamAdorns
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

function Backend3D.LoadObject(Path, Object)
    local DreamObject = Dream:loadObject(Path)

    if type(Object) == "table" then
        AssignClassReference(DreamObject, Object)

        DreamWorld.objects[Object.UUID] = DreamObject
    else -- assume custom uuid
        print(Path)
        DreamAdorns.objects[Object] = DreamObject
    end

    return DreamObject
end

function Backend3D.RemoveObject(Object)
    if type(Object) == "table" then
        DreamWorld.objects[Object.UUID] = nil
    else -- assume adorn
        DreamAdorns.objects[Object] = nil
    end
end

return Backend3D