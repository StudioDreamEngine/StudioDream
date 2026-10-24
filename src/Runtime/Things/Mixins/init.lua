local Mixels = {}

function Mixels.Init()
end

function Mixels.Type(Name)
    return require("Runtime.Things.Mixins."..Name)
end

function Mixels.Create(Object,Type)    
    local Typed = Mixels.Type(Type)
    local Mixel = Typed.link(Object)

    return Mixel
end

return Mixels