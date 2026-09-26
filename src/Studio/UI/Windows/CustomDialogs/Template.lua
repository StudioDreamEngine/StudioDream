local Template = {}

function Template.Init(Parented,Info)
    local DialogObject = {}

    function DialogObject:Create()
        
    end

    function DialogObject:Init()
        self.Objects = {}

        self:Create()
    end

    function DialogObject:Destroy()
        for i,v in pairs(self.Objects) do
            v:Destroy()
        end

        table.clear(self.Objects)
        table.clear(DialogObject)
    end

    return DialogObject
end

return Template