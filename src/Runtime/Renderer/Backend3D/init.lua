---@diagnostic disable: inject-field
-- Many utility functions related to the 3d engine, also handles adorns

--[[
    ADORNS:
        An adorn is an object that is unlike regular thing objects

        these are directly rendered to the screen and are meant to be used for gizmos
        that should not be treated as regular objects


]]
local Backend3D = {}
local DreamAdorns = {}

Dream.skyRenderer = require("Runtime.Renderer.Backend3D.RenderSky")

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

-- Set the transform of the debug object
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

-- Register an adorn, making it renderable
-- if an adorn is parented to another adorn, you do not need to register it.
function Backend3D.RegisterAdorn(Object, UUID)
    DreamAdorns[UUID] = Object
end

function Backend3D.UpdateBounds(Mesh, Scale)
    return Dream:newBoundingSphere(Mesh:updateBoundingSphere(Scale:Magnitude()))
end

-- Create an adorn object
function Backend3D.CreateAdorn(Name)
    local Object = Dream:newTransformable()
    Object.name = Name
    Object.BoundingSphere = Dream:newBoundingSphere()
    Object.isAdorn = true
    Object.material = Runtime.Things.CreateTemplate("Material")
    Object.objects = {}

    Object.UUID = CreateUUID()

    return Object
end

-- Load a mesh into a 3dreamengine mesh object from an identifier
function Backend3D.LoadMesh(Identifier, Reference)
    local Resource, ResourceIdentifier = Runtime.Resources.LoadResourceFromIdentifier(Identifier, Reference, "Mesh")
    if (not Resource) then return end

    AssignClassReference(Resource, Reference) -- TODO/FIXME: DONT DO THIS!!!! IT FUCKS WITH RAYCAST

    return Resource, ResourceIdentifier
end

-- Create an adorn object and load a mesh into it.
function Backend3D.LoadAdorn(Identifier, Parent, Reference)
    local Adorn = Backend3D.CreateAdorn(Reference)

    local DreamMesh = Backend3D.LoadMesh(Identifier, Adorn)
    DreamMesh.isAdorn = true

    Adorn.BoundingSphere = Backend3D.UpdateBounds(DreamMesh, Vector2.one * 5)
    Adorn.mesh = DreamMesh

    AssignClassReference(Adorn, Reference)

    Parent.objects[Adorn.UUID] = Adorn
    return Adorn
end

-- Present all adorns specified within the objects table
function Backend3D.PresentAdornChild(Objects, Transform)
    for _, Object in pairs(Objects) do
        local Transform = Object.transform and (Object.transform * Transform) or Transform

        if Object.mesh then
            Dream:addMesh(Object.mesh, Transform, Object.material.MaterialList)
        end

        if Object.objects then
            Backend3D.PresentAdornChild(Object.objects, Object.transform or Transform)
        end
    end
end

-- Present all registered adorn objects
function Backend3D.PresentAdorns()
    Backend3D.PresentAdornChild(DreamAdorns, Dream.mat4.getIdentity())
end

function Backend3D.UnregisterAdorn(Object)
    DreamAdorns[Object] = nil
end

return Backend3D