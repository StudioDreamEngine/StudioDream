---@diagnostic disable: inject-field
local Backend3D = {}
local DreamAdorns = {}

--[[
    ADORNS VS OBJECTS:
        Adorns imitate regular 3DE objects, when one is used in for example a raycast, a special version of the code is used for said object

        Objects however are simply just drawable3d objects
]]

function Backend3D.SetupDebug()
    Backend3D.Debug = Runtime.Things.Create("Drawable3D") {
        Transform = Transform3D.FromPosition(0,-100,0),
        Resource = "Internal/DefaultMeshes/cube.obj"
    }
end

function Backend3D.SetTransform(Transform)
    Backend3D.Debug:SetTransform(Transform)
end

function Backend3D.GetAdorns() return DreamAdorns end

--- Assign all DreamObjects the ClassReference object, instead of merging the object into one single mesh
--- @param Object DreamObject
--- @param ClassReference Drawable3D
local function AssignClassReference(Object, ClassReference)
    Object.ClassReference = ClassReference
end

-- Object stuff --

function Backend3D.RegisterObject(Object, UUID)
    DreamAdorns[UUID] = Object
end

function Backend3D.UnregisterObject(UUID)
    DreamAdorns[UUID] = nil
end

-- Adorns will use a watered down version of a 3de object, but not literally one
function Backend3D.CreateAdorn(Name)
    local Object = Dream:newTransformable()
    Object.name = Name
    Object.isAdorn = true
    Object.material = Runtime.Things.New("Material")
    Object.objects = {}

    Object.UUID = CreateUUID()

    DreamAdorns[Object.UUID] = Object
    return Object
end

function Backend3D.LoadMesh(Identifier, Reference)
    local Resource, ResourceIdentifier = Runtime.Resources.LoadResourceFromIdentifier(Identifier, Reference, "Mesh")
    if (not Resource) then return end

    Resource:updateBoundingSphere()

    AssignClassReference(Resource, Reference)

    return Resource, ResourceIdentifier
end

function Backend3D.LoadAdorn(Identifier, Parent, Reference)
    local Adorn = Backend3D.CreateAdorn(Reference)

    local DreamMesh = Backend3D.LoadMesh(Identifier, Reference)
    local UUID = CreateUUID()

    DreamMesh.isAdorn = true
    DreamMesh.UUID = UUID

    Adorn.mesh = DreamMesh

    Parent.objects[UUID] = Adorn
    return Adorn
end

function Backend3D.PresentAdornChild(Objects, Transform)
    for _, Object in pairs(Objects) do
        local Transform = Object.transform and (Object.transform * Transform) or Transform

        if Object.mesh then
            Dream:addMesh(Object.mesh, Transform, Object.material)
        end

        if Object.objects then
            Backend3D.PresentAdornChild(Object.objects, Object.transform or Transform)
        end
    end
end

function Backend3D.PresentAdorns()
    Backend3D.PresentAdornChild(DreamAdorns, Dream.mat4.getIdentity())
end

function Backend3D.RemoveAdorn(Object)
    DreamAdorns[Object] = nil
end

return Backend3D