local PhysicsEngine = {}

function PhysicsEngine.CreateShape(Size)
    return Bullet.btBoxShape(Size.ToBullet())
end

-- dream to bullet
function PhysicsEngine.ToBullet(DreamTransform)
    local Transform = Bullet.btTransform()
    --Transform:setFromOpenGLMatrix(DreamTransform.GetMatrix())
    Transform:setIdentity()
    Transform:setOrigin(DreamTransform.Position.ToBullet())
    return Transform
end

-- bullet to dream
function PhysicsEngine.FromBullet(BulletTransform)
    local Origin = BulletTransform:getOrigin()

    local Transform = Transform3D.FromPosition(Origin:x(), Origin:y(), Origin:z())

    local Rotation = BulletTransform:getRotation()

    return Transform
end

function PhysicsEngine.CreateBody(Shape, Transform, IsDynamic)
    local LocalInertia = Bullet.btVector3(0, 0, 0)
    Shape:calculateLocalInertia(IsDynamic and 1 or 0, LocalInertia);

    local MyMotionState = Bullet.btDefaultMotionState(Transform)
    local rbInfo = Bullet.btRigidBodyConstructionInfo(IsDynamic and 1 or 0, MyMotionState, Shape, LocalInertia)

    return Bullet.btRigidBody(rbInfo)
end

return PhysicsEngine