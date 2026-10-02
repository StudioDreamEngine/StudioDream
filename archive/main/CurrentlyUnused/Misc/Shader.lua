local Shader = Things.Extend("Thing")

function Shader:new() -- maybe a special window that ask u if u want to start with an preloaded shader? aka outlines ect ect
    Shader.super.new(self)

    self.Explorer = {
        Icon = "File_With_Problem",
        Visible = true
    }
    self.ShaderConfigs = {
        InsertStuffHereWow = true
    }

end

function Shader:Update(dt)
    Shader.super.Update(self,dt)

end

return Shader