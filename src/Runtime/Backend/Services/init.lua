local Services = {}

Services.Services = {}

function Services.LoadService(Service)
    if (not Services.Services[Service]) then
        Services.Services[Service] = require("Runtime.Backend.Services."..Service)
    end

    return Services.Services[Service]
end

function Services.CallAll(Function, ...)
    for _, Service in pairs(Services.Services) do
        if Service[Function] then
            Service[Function](...)
        end
    end
end

function Services.Init()
    Services.CallAll("Init")
end

function Services.Update(dt)
    Services.CallAll("Update", dt)
end

return Services