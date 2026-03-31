-- Basic Container class
return { new = function(Base)
    local Container = Base

    function Container.Ready() end
    function Container.Update(dt) end

    return Container
end }