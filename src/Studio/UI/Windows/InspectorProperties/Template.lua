local Template = Object:extend()

function Template:new(Property)
    --self.Asset = self:CreateProperty()
    self.IsActive = Property.IsActive

    return self
end

function Template:ReAssing(Data)

end

function Template:CreateVisual()

end

function Template:Destroy()

end

return Template