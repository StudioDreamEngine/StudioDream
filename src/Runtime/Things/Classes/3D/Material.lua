local Things = Runtime.Things

-- SCRAPPED!!!

---@class Material: Thing
local Material = Things.Extend("Thing")

function Material:new()
    Material.super.new(self)

    self.DreamMaterial = Dream:newMaterial(self.Name)
end

function Material:DefineAPI()
    Material.super.DefineAPI(self)

    --self.Proxy.MakeCreatable()
end

return Material