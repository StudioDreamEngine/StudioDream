local Things = {}

-- AllThings doesnt roll off the tounge as well
local Objects = {}

function Things.Get(UUID)
    
end

-- TODO: Make this create the base object itself, idk how we should do extensions and such tbh :sob:
function Things.Type(ThingType) return require("Runtime.Engine.Things."..ThingType) end
local BaseThing = Things.Type("Thing")

function Things.New(ThingType, ...)
    local Module = Things.Type(ThingType)
    local Thing = Module.new(BaseThing.new())

    Thing.UUID = UUID()
    Thing.Name = ThingType

    Utils.OptionalCall(Thing, "Ready")
    Objects[Thing.UUID] = Thing

    return Thing
end

function Things.Update(dt)
    for _, Thing in Objects do
        Utils.OptionalCall(Thing, "Update", dt)
    end
end

return Things