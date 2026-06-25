local Things = Runtime.Things
local Properties = {}

Properties.Container = nil ---@class Square

Properties.ParentWith = nil

Properties.PropertiesRequired = {}

Properties.RequiredTypes = {}

local LineUp_Button = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

function Properties.RequireType(TypeReturned)
    if Utils.FileExists("Studio/UI/Windows/PropertiesTypes_New/" .. TypeReturned .. ".lua") then
        if not Properties.RequiredTypes[TypeReturned] then
            Properties.RequiredTypes[TypeReturned] = require("Studio/UI/Windows/PropertiesTypes_New/" .. TypeReturned)
        end
        return Properties.RequiredTypes[TypeReturned]
    end
    if TypeReturned ~= "NotFound" then
        return Properties.RequireType("NotFound")
    end
    return nil
end

function Properties.CreateProperty(PropertyInfos,ParentWhat)
    local selfed = {}

    local PropertyWillHandle = {
        {
            Thing = PropertyInfos.Thing,
            PropertyName = PropertyInfos.Name
        },
    }

    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.99,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        CornerRadius = 6,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }

    selfed.Option = Things.Create("Square") {
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = selfed.BaseProperty,
        CornerRadius = 2,
    }

    selfed.Text = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.49,.9),
        Position = Pivot2D.FromScale(0.005,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyInfos.Name,
        Parent = selfed.BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }

    selfed.Connections = PropertyInfos.Connections
    selfed.WillHandle = PropertyWillHandle
    
    return selfed
end

function Properties.CreateGroup(GroupName,ParentWhat)
    local selfed = {}

    selfed.Connections = {} -- this will also handle Property connections, so when reloading they all disconnect

    selfed.IsOpen = true
    
    selfed.BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,25,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
      --  OutlineSize = 2,
      --  OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        CornerRadius = 2,
    }

    selfed.TextOfGroup = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,0.8),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Parent = selfed.BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    selfed.Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,0.8),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = selfed.BaseGroup,
        Rect = Rect.new(Vector2.new(64,0),Vector2.new(64,64))
    }

    selfed.GroupList = Things.Create("Square") { 
        Size = Pivot2D.FromScale(.98,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        CornerRadius = 2,
    }
    
    selfed.ListLayout = Things.Create("ListLayout") {
        Parent = selfed.GroupList,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2,
    }
    
    function selfed.OpenFunction(UseMe) 
        selfed.IsOpen = not selfed.IsOpen
        selfed.Button:SetImageRect(Rect.new(LineUp_Button[tostring(UseMe and UseMe or selfed.IsOpen)],Vector2.new(64,64)))
        selfed.GroupList.Visible = UseMe and UseMe or selfed.IsOpen
    end

    selfed.OpenFunction(selfed.IsOpen) 

    selfed.Connections[Utils.CountTable(selfed.Connections)+1] = selfed.Button.Clicked:Connect(selfed.OpenFunction)

    return selfed
end

function Properties.RenderEverything(Thing)
    Properties.ParentWith:ClearAllChildren({"ListLayout"})

    for GroupName,v in pairs(Thing.Proxy.Groups) do
        local ReturnedFromGroup = Properties.CreateGroup(GroupName)
        local GroupToParent = ReturnedFromGroup.GroupList

        for v,Property in pairs(Thing.Proxy.Groups[GroupName]) do
            local PropertyInfo = {
                Name = Property,
                Thing = Thing,
                Type = nil,
                --ConnectHere = ReturnedFromGroup.Connections
            }

            if Thing.Proxy.Types[Property] then PropertyInfo.Type = Thing.Proxy.Types[Property] end

            local Required,TypeReturned = Properties.RequireType(PropertyInfo.Type)
            --assert(Type, Thing.ClassName.." has improperly defined property "..Property)
            local PropertyReturn = Properties.CreateProperty(PropertyInfo,GroupToParent)
            Required.Start(PropertyReturn)
        end
    end
end

function Properties.Init()
    Properties.ParentWith = Things.Create("ScrollContainer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Parent =  Properties.Container,
    }

    Things.Create("ListLayout") {
        Parent = Properties.ParentWith,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2
    }
    Studio.Editor3D.OnSelect:Connect(Properties.RenderEverything)
end

function Properties.Update(dt)
    
end
return Properties