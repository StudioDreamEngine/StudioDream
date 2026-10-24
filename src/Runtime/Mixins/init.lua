local Mixels = {}

function Mixels.Init()
    Mixels.TypesString = Utils.LoadModules("Runtime/Mixins/Mixels/",true)
end

function Mixels.Type(Name)
    return Mixels.TypesString[Name]
end

function Mixels.Create(Object,Type)    
    local Typed = Mixels.Type(Type)
    local Mixel = Typed.link(Object)

    return Mixel
end

return Mixels