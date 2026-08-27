local Things = Runtime.Things

---@class Assets: Thing
local Assets = Things.Extend("Thing")

function Assets:new()
    Assets.super.new(self)
end

function Assets:DefineAPI()
    Assets.super.DefineAPI(self)

    self.Proxy.SetHiperType("Containers")

    self.Proxy.Icon("Assets")
    self.Proxy.MakeNonDuplicatable()
end

return Assets