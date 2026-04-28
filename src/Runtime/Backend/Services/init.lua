local Services = {}

Services.Services = {}

function Services.Service(Service)
    if (not Services.Services[Service]) then
        print("Initalizing Service: "..Service)

        Services.Services[Service] = require("Runtime.Backend.Services."..Service)
        Services.Services[Service].Init()
    end

    print("Returning Already-Initalized Service: "..Service)

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

return Services