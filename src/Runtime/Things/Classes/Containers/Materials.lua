local Things = Runtime.Things

---@class Materials: Thing
local Materials = Things.Extend("Thing")

function Materials:DefineAPI()
    Materials.super.DefineAPI(self)

    --self.Proxy.Icon("Environment")
end

return Materials