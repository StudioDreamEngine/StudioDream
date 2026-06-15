local Environment = root:GetEnvironment()

---@class RenderService
local RenderService = service("RenderService")

RenderService.OnStep:Connect(function()
    Environment:FindFirstChild("Mesh"):SetTransform(Transform3D.FromAngle(0,GlobalTick,0) * Transform3D.FromPosition(0, math.sin(GlobalTick * 4) / 2, -5))
end)