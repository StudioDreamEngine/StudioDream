local Debug = {}
local Services = Runtime.Services
local Things = Runtime.Things

function Debug.Init()
    Services.Service("InputService").InputBegan:Connect(function(Key)
        local Environment = Things.GetRoot("Environment")

        print(Key)

        if Key == "F" then
            print("a")

            print(Runtime.MouseHit.Hit)
            print(Runtime.MouseHit.Target)
        end
    end)
end

return Debug