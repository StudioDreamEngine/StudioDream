local Environment = root:GetEnvironment()

print("Start script")

---@class RenderService
local RenderService = service("RenderService")

RenderService.OnStep:Connect(function()
    print("Stepping")
    
    Environment:FindFirstChild("Mesh"):SetTransform(Transform3D.FromAngle(0,time(),0) * Transform3D.FromPosition(0, math.sin(time() * 4) / 2, -5))
end)

function LoopThoughtEnv()
    for i,v in pairs(Environment:GetChildren()) do
        print(i,v)
    end
end

LoopThoughtEnv()