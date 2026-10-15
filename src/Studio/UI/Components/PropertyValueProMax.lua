local PropertyValue = Object:extend()

local RenderTypes = {
    ["Input"] = function(Data)
        local Input = {}

        function Input:Start() -- Calls after Render, here is where the functionality comes, if the property is disabled, doesnt get called

        end

        function Input:Render() -- Calls first to render the visuals

        end

        function Input:OnDestroy() -- called when Render is switched, or PropertyValue is destroyed

        end

        return Input
    end
}

function PropertyValue.new(Data)
    local self = {}
    setmetatable(PropertyValue,self)

    self.LastRenderType = nil

    self:RenderVisuals(Data)
end

function PropertyValue:RenderType(Type)
    self.LastRenderType = Type
end

function PropertyValue:RenderVisuals(Data) -- always assing the visuals with self.UI, same for rendertype visual

end

return PropertyValue