local Things = Runtime.Things

---@class LocalTransformable3D: Transformable3D
local LocalTransformable3D = Things.Extend("Transformable3D")

function LocalTransformable3D:UpdateWorldPos()
    print("!!!!")
    print(Transform3D.FromPosition(self.Parent.Transform.Position)*Transform3D.FromAngle(self.Parent.Transform.AsAngle())*self.LocalTransform)
    self:SetTransform(Transform3D.FromPosition(self.Parent.Transform.Position)*Transform3D.FromAngle(self.Parent.Transform.AsAngle())*self.LocalTransform)
end

function LocalTransformable3D:new()
    LocalTransformable3D.super.new(self)

    self.LocalTransform = Transform3D.FromPosition(0,0,0)

    self.ParentConnectioned = nil
end

function LocalTransformable3D:DefineAPI()
    LocalTransformable3D.super.DefineAPI(self)

    self.Proxy.SetCategory("3D")
    
    self.Proxy.Property("Transform3D LocalTransform")
    self.Proxy.Group("Transform","LocalTransform")
end

function LocalTransformable3D:UpdateParentSituation()
        if self.ParentConnectioned then
            self.ParentConnectioned:DisconnectAll()
            print("Yes111!")
        end
        
        if self.Parent:IsA("Transformable3D") then
            print("Yes!")
            self.ParentConnectioned = self.Parent.PropertyChanged:Connect(function(Key,Val)
                print(Key,Val)
                if Key == "Transform" then
                    self:UpdateWorldPos()
                end
            end)
        end
end

function LocalTransformable3D:OnReady()
    LocalTransformable3D.super.OnReady(self)

    if self.Parent then
        self:UpdateWorldPos()
    end
    print("This!")
    print(self.Parent)
    self.ParentChanged:Connect(function()
        self:UpdateParentSituation()
    end)
end

function LocalTransformable3D:SetLocalTransform(NewTransform)
    self.LocalTransform = NewTransform
    if self.Parent then
        self:UpdateWorldPos()
    end
end

function LocalTransformable3D:OnRemove()
    LocalTransformable3D.super.OnRemove(self)
    
    self.ParentConnectioned:DisconnectAll()
end

--[[function LocalTransformable3D:SetParent(Parent)
    LocalTransformable3D.super.SetParent(Parent,self)

    --[[if self.ParentConnectioned then
        self.ParentConnectioned:DisconnectAll()
    end
    
    if Parent:IsA("Transformable3D") then
        self.ParentConnectioned = Parent.PropertyChanged:Connect(function(Key,Val)
            if Key == "Transform" then
                self:UpdateWorldPos()
            end
        end)
    end
end]]

return LocalTransformable3D