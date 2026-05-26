-- idk what to call this
-- basically stores all api related stuff, icons, if an object is creatable, etc etc

return { new = function()
    ---@class ObjectProxy
    local ObjectProxy = {}

    ObjectProxy.Creatable = false
    ObjectProxy.ExplorerIcon = "Square"

    ObjectProxy.Serializable = {}
    ObjectProxy.Accessible = {}

    ObjectProxy.Types = {}
    ObjectProxy.Groups = {}

    ObjectProxy.Proxies = {}
    ObjectProxy.Overrides = {}

    -- Virtuals for Info functions
    function ObjectProxy.ConstraintUpdator() end

    -- Code reuse.... 
    -- Fucking hell cant do shit in this codebase

    local function ProcessProperty(Table, Property)
        local Split = string.split(Property, " ")
        local Name, Type = nil, "undefined"

        if #Split > 1 then
            Name = Split[2]
            Type = Split[1]
        else
            Name = Property
        end

        Table[Name] = true
        ObjectProxy.Types[Name] = Type
    end

    function ObjectProxy.Icon(Icon)
        ObjectProxy.ExplorerIcon = Icon
    end

    -- Add a property that can be serialized and used by scripts
    function ObjectProxy.Property(...)
        ObjectProxy.PropertyAccess(...)
        ObjectProxy.PropertySerialize(...)
    end

    function ObjectProxy.MakeCreatable()
        ObjectProxy.Creatable = true
    end

    -- Add an accessible only property
    function ObjectProxy.PropertyAccess(...)
        for i, v in pairs(table.pack(...)) do
            if i ~= "n" then
                ProcessProperty(ObjectProxy.Accessible, v)
            end
        end
    end

    -- Add an serializable only property
    function ObjectProxy.PropertySerialize(...)
        for i, v in pairs(table.pack(...)) do
            if i ~= "n" then
                ProcessProperty(ObjectProxy.Serializable, v)
            end
        end
    end

    function ObjectProxy.Group(Group, ...)
        if (not ObjectProxy.Groups[Group]) then
            ObjectProxy.Groups[Group] = {}
        end

        for i, v in pairs(table.pack(...)) do
            if i ~= "n" then
                table.insert(ObjectProxy.Groups[Group], v)
            end
        end
    end

    function ObjectProxy.Info(InInfo)
        for i, v in pairs(InInfo) do
            ObjectProxy[i] = v
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