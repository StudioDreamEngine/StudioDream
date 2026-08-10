-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

local SelectionPriority = Runtime.SelectionPriority

---@class Control3D: Base3D
local Control3D = Things.Extend("Base3D")

function Control3D:new()
    Control3D.super.new(self)

    self.Adornee = nil ---@class Drawable3D

    self.ControlChanged = Signal:New("Control")
    self.EndControl = Signal:New("EndControl")
    self.StartControl = Signal:New("StartControl")

    self.Down = false
    self.Hovering = nil

    self.GridSnap = 10
    self.RotationSnap = 10 -- TODO
    
    self.AdornObject = Runtime.Backend3D.CreateAdorn("ControlAdorn")
    self.Adorns = {}

    for Axis, Color in pairs(self.Lookup) do
        local Material = Things.New("Material")
        Material.Color = Color
        Material.Alpha = true
        Material.Simple = true
        Material.DepthTest = false

        local Object = Runtime.Backend3D.LoadAdorn(self.Resource, self.AdornObject, Axis)
        Object:setMaterial(Material)

        self.Adorns[Axis] = {
            Adorn = Object,
            Material = Material
        }
    end

    self:ConnectEvents()
end

function Control3D:UpdateGrid(Name,ToWhat)
    self[Name.."Snap"] = ToWhat
end

function Control3D:Snap(Value, By)
    if By < 0.01 then return Value end -- Epsilon :3

    if Utils.TypeOf(Value) == "Vector3" then
        return (Value.Round() / By) * By
    else
        return math.round(Value / By) * By
    end
end

function Control3D:ConnectEvents()
    printVerbose("Connect move events")

    self.MouseEvent = SelectionPriority.BindSignal(function(IsDown)
        if IsDown then
            self.StartControl.Invoke()
            self.Down = self.Hovering

            self:OnStart()
        else
            self.Down = false 
            self.EndControl.Invoke() 
        end
    end, 2, function ()
        return self.Hovering or self.Down
    end)

    self.MouseMoved = InputService.MouseMoved:Connect(function(MouseObject)
        if (not self.Down) then return end

        self:OnChange()
    end)
end

function Control3D:OnRemove()
    Runtime.Backend3D.RemoveAdorn(self.AdornObject.UUID)
    self:DisconnectEvents()

    Control3D.super.OnRemove(self)
end

function Control3D:DisconnectEvents()
    SelectionPriority.UnbindSignal(self.MouseEvent)
    self.MouseMoved:Disconnect()
end

function Control3D:DefineAPI()
    Control3D.super.DefineAPI(self)

    self.Proxy.Property("Thing Adornee")
end

function Control3D:Update(dt)
    if (not self.Adornee) then return end

    ---@class Camera
    local Camera = Things.Root:GetCamera()
    if not (Camera or Camera.Position) then return end

    local Transform = self.Adornee.Transform

    local CameraDistance = (Transform.Position - Camera.Position):Magnitude()
    CameraDistance = math.sqrt(CameraDistance) / 8 -- Black magic, Literally black magic.

    local Hovering = SpatialService.Raycast(Camera.Position, Camera:GetMouseRay()*400, self.AdornObject)
    self.Hovering = Hovering

    for Axis, Data in pairs(self.Adorns) do
        local Adorn = Data.Adorn
        local OldColor = Data.Material.Color

        local Alpha
        local HoveringID = self.Hovering and self.Hovering.UUID
        local DownID = self.Down and self.Down.UUID

        if (Adorn.UUID == DownID) then Alpha = 0.8
        elseif (Adorn.UUID == HoveringID) then Alpha = 0.6
        else Alpha = 0.4 end

        Data.Material.Color = Color.new(OldColor.R, OldColor.G, OldColor.B, Alpha)

        self:UpdateAdorn(Axis, Adorn, Transform, CameraDistance)
    end
end

return Control3D