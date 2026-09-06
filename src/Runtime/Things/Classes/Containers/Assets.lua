local Things = Runtime.Things

---@class Assets: Scene
local Assets = Things.Extend("Scene")

function Assets:new()
    Assets.super.new(self)
end

function Assets:DefineAPI()
    Assets.super.DefineAPI(self)

    self.Proxy.SetCategory("Containers")

    self.Proxy.Icon("Assets")
    self.Proxy.MakeNonDuplicatable()
end

return Assets