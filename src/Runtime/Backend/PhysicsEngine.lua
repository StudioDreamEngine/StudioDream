-- General utility functions for the physics engine
local PhysicsEngine = {}

-- Shape from mesh code, thanks to trusti for providing this
function PhysicsEngine.ShapeFromMesh(m, size)
    local tm = Bullet.btTriangleMesh()

    local vs = m.vertices:getSize()
    local nvs = {}
    for i=1,vs do
        local v = m.vertices:get(i)
        nvs[i] = {x = v.x * size.X, y = v.y  * size.Y, z = v.z  * size.Z}
    end

    local fs = m.faces:getSize()
    local nfs = {}
    for i=1,fs do
        local v = m.faces:get(i)
        table.insert(nfs, {x = v.x, y = v.y, z = v.z})
    end

    local v1 = Bullet.btVector3(0, 0, 0)
    local v2 = Bullet.btVector3(0, 0, 0)
    local v3 = Bullet.btVector3(0, 0, 0)
    for _,v in pairs(nfs) do
        local p1 = nvs[v.x]
        local p2 = nvs[v.y]
        local p3 = nvs[v.z]
        v1:setValue(p1.x, p1.y, p1.z)
        v2:setValue(p2.x, p2.y, p2.z)
        v3:setValue(p3.x, p3.y, p3.z)
        tm:addTriangle(v1, v2, v3, true)
    end

    local cvs = Bullet.btConvexTriangleMeshShape(tm, true)
    cvs.meshDataReference = tm

    return cvs
end

function PhysicsEngine.CreateShape(Size)
    return Bullet.btBoxShape(Size:ToBullet())
end

-- dream to bullet
function PhysicsEngine:ToBullet(DreamTransform)
    local Matrix = DreamTransform.GetMatrix()

    local Transform = Bullet.btTransform()
    Transform:setFromOpenGLMatrix({
        Matrix[1], Matrix[5], Matrix[9], Matrix[13],
		Matrix[2], Matrix[6], Matrix[10], Matrix[14],
		Matrix[3], Matrix[7], Matrix[11], Matrix[15],
		Matrix[4], Matrix[8], Matrix[12], Matrix[16],
    })

    return Transform
end

-- bullet to dream
function PhysicsEngine.FromBullet(BulletTransform)
    local Origin = BulletTransform:getOrigin()
    local Basis = BulletTransform:getBasis()

    -- idiotic hack to get around weird cache issues
    local Row1 = Basis:getRow(0)
    Row1 = {Row1:x(), Row1:y(), Row1:z()}

    local Row2 = Basis:getRow(1)
    Row2 = {Row2:x(), Row2:y(), Row2:z()}

    local Row3 = Basis:getRow(2)
    Row3 = {Row3:x(), Row3:y(), Row3:z()}

    local Matrix = Dream.mat4({
		Row1[1], Row1[2], Row1[3], Origin:x(),
		Row2[1], Row2[2], Row2[3], Origin:y(),
		Row3[1], Row3[2], Row3[3], Origin:z(),
		0, 0, 0, 1
	})

    return Transform3D.FromMatrix(Matrix)
end

-- Create the actual rigidbody used for a drawable
function PhysicsEngine.CreateBody(Shape, Transform, IsDynamic)
    local LocalInertia = Bullet.btVector3(0, 0, 0)
    Shape:calculateLocalInertia(IsDynamic and 1 or 0, LocalInertia);

    local MyMotionState = Bullet.btDefaultMotionState(Transform)
    local rbInfo = Bullet.btRigidBodyConstructionInfo(IsDynamic and 1 or 0, MyMotionState, Shape, LocalInertia)

    return Bullet.btRigidBody(rbInfo)
end

return PhysicsEngine