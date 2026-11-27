local ffi = require("ffi")

---@diagnostic disable-next-line: param-type-mismatch
local joltLib
local jolt = {}

function jolt.Load()
    joltLib = ffi.load(package.searchpath("libjoltc", package.cpath))

    local Header = love.filesystem.read("Shared/Packages/JoltPhys/Jolt.h")
    assert(Header, "Couldnt find joltC header")

    ffi.cdef(Header)
end

-- Create basic systems needed for jolt, as per the joltc hello world
function jolt.Init()   
    printVerbose("Initalizing jolt")
    jolt.Load()

    joltLib.JPH_RegisterDefaultAllocator()
    joltLib.JPH_SetTraceHandler(function(...)
        print(...)
    end)

    joltLib.JPH_CreateFactory()
    joltLib.JPH_RegisterTypes()

    jolt.Allocator = joltLib.JPH_TempAllocatorImpl_Create(1 * 1024 * 1024)
    jolt.JobSystem = joltLib.JPH_JobSystemThreadPool_Create(nil)

    local bplInterface = joltLib.JPH_BroadPhaseLayerInterfaceTable_Create(2,2)
    joltLib.JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(bplInterface, 0,0);
    joltLib.JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(bplInterface, 1,1);

    local objectLayerPairFilter = joltLib.JPH_ObjectLayerPairFilterTable_Create(2);
    joltLib.JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, 0, 1);
    joltLib.JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, 1, 0);

    local objectVsBroadPhaseLayerFilter = joltLib.JPH_ObjectVsBroadPhaseLayerFilterTable_Create(bplInterface, 2, objectLayerPairFilter, 2)

    jolt.DefaultSettings = ffi.new("JPH_PhysicsSystemSettings", {
        maxBodies = 1024,
        numBodyMutexes = 0,
        maxBodyPairs=1024,
        maxContactConstraints=1024,
        broadPhaseLayerInterface = bplInterface, -- for some reason i only need this,
        objectVsBroadPhaseLayerFilter = objectVsBroadPhaseLayerFilter,
        objectLayerPairFilter = objectLayerPairFilter,
    })

    print("Jolt physics is Ready")

    local World = jolt.NewPhysicsWorld()
    local Shape = jolt.CreateShape(Enum.PhysicsShape.Cube, {
        Size = Vector3.one * 10
    })

    print("Created shape and world")

    jolt.CreateBody(World.Interface, nil, Shape)
end

function jolt.NewPhysicsWorld()
    local PhysicsSystem = joltLib.JPH_PhysicsSystem_Create(jolt.DefaultSettings)
    local Interface = joltLib.JPH_PhysicsSystem_GetBodyInterface(PhysicsSystem)

    return {
        Physics = PhysicsSystem, 
        Interface = Interface
    }
end

function jolt.ConvertType(Object, Type)
    if Type == "Vector3" then -- Convert a list-based Vector3 to a jolt vector3
        local Vector = ffi.new("JPH_Vec3", {
            x = Object.X,
            y = Object.Y,
            z = Object.Z
        })
    
        return Vector
    end
end

function jolt.CreateShape(ShapeType, Data)
    local Shape

    if ShapeType == "Box" then
        Shape = joltLib.JPH_BoxShape_Create(jolt.ConvertType(Data.Size, "Vector3"), 0.05)
    --elseif ShapeType == "Sphere" then
    --    local ShapeSettings = joltLib.JPH_BoxShapeSettings_Default()
    --    ShapeSettings.halfExtent = jolt.ConvertType(Data.Size, "Vector3")
    else
        error("Unsupported Shape "..ShapeType)
    end
    
    return Shape
end

function jolt.MakeQuat()
    return ffi.new("JPH_Quat", {
        x = 0,
        y = 0,
        z = 0,
        w = 1
    })
end

function jolt.CreateBody(Interface, CreationSettings, Shape)
    local Position = ffi.new("JPH_RVec3", {
        x = 0,
        y = -1,
        z = 0
    })

    local DefaultSettings = joltLib.JPH_BodyCreationSettings_Create3(
        ffi.cast("const struct JPH_Shape *", Shape),
        Position,
        nil,
        1,
        1
    )

    assert(not CreationSettings, "CreationSettings not supported")

    local Body = joltLib.JPH_BodyInterface_CreateBody(Interface, DefaultSettings)

    return DefaultSettings, Body
end

function jolt.StepPhysicsWorld(DeltaTime, CollisionSteps)
    
end

function jolt.Destroy()
    joltLib.JPH_UnregisterTypes()
    joltLib.JPH_DestroyFactory()
    joltLib.JPH_JobSystem_Destroy(jolt.JobSystem)
end

return jolt
