-- idk what to call this
-- basically stores what properties are accessible, serializable, and what calls need their objects proxied

return { new = function()
    local ObjectProxy = {}

    ObjectProxy.Serializable = {}
    ObjectProxy.Accessible = {}

    ObjectProxy.Proxies = {}
    ObjectProxy.Overrides = {}

    -- Code reuse.... 
    -- Fucking hell cant do shit in this codebase

    -- Add a property that can be serialized and used by scripts
    function ObjectProxy.Property(...)
        ObjectProxy.PropertyAccess(...)
        ObjectProxy.PropertySerialize(...)
    end

    -- Add an accessible only property
    function ObjectProxy.PropertyAccess(...)
        for i, v in pairs(table.pack(...)) do
            if i ~= "n" then
                ObjectProxy.Accessible[v] = true
            end
        end
    end

    -- Add an serializable only property
    function ObjectProxy.PropertySerialize(...)
        for i, v in pairs(table.pack(...)) do
            if i ~= "n" then
                ObjectProxy.Serializable[v] = true
            end
        end
    end

    function ObjectProxy.IsAccessible(Property)
        return ObjectProxy.Accessible[Property]
    end

    -- For now, if its both accessible and serializable, its writable
    --[[function ObjectProxy.IsWritable(Property)
        return ObjectProxy.Accessible[Property] and ObjectProxy.Serializable[Property]
    end]]

    --[[
        Add a call that needs some form of instance proxy conversion when used
        Not nesscessarily serialization related, but ig it will go here until we find a better name for this

        CallName: The name of the method
        FromTable: If the method returns a table
    ]]
    function ObjectProxy.ProxiedCall(CallName, FromTable)
        
    end
    
    return ObjectProxy
end }