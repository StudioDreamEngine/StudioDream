local Debug = {}
local Services = Runtime.Services
local Things = Runtime.Things

function Debug:Init()
    print("Start debugservice")
    Services.InputService.InputBegan:Connect(function(Key)
        local Environment = Things.GetRoot("Environment")

        if Key == "F" then
            print(Runtime.MouseHit.Hit)
            print(Runtime.MouseHit.Target)
        end
    end)
end

return Debug