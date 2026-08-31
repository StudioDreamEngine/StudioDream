local Services = {}

Services.Services = {}

Shared.OnQuit:Connect(function()
    printVerbose("Gracefully exiting services...")
    Runtime.Services.OnQuit()
end)

function Services.Service(Service)
    if (not Services.Services[Service]) then
        print("Initalizing Service: "..Service)

        Services.Services[Service] = require("Runtime.Backend.Services."..Service)
        Services.Services[Service].Init()
    end

    printVerbose("Returning Already-Initalized Service: "..Service)

    return Services.Services[Service]
end

function Services.CallAll(Function, ...)
    for _, Service in pairs(Services.Services) do
        if Service[Function] then
            Service[Function](...)
        end
    end
end

function Services.Update(dt)
    Services.CallAll("Update", dt)
end

function Services.OnQuit()
    Services.CallAll("OnDestroy")
end

return Services