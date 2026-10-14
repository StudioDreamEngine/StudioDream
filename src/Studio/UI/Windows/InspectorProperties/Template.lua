local Template = Object:extend()

function Template.new(Data)
    local self = {}
    setmetatable(self,Template)

    self.Asset = self:CreateProperty()
end

function Template:ReAssing(Data)

end

function Template:CreateProperty()

end

return Template