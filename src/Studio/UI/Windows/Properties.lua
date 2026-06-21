
local PropertiesRender = {}
local Things = Runtime.Things
local RequiredPropertyTypes = {}

local LineUp_Button = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local function ReturnFirst(table)
    for i,v in pairs(table) do
        return i
    end
end

local function CreatePropertyNode(Window,PropertyTxt,Type,Thing,Index)
    local PropertyBased = {}

    Type = (Thing.Proxy.Attributes[PropertyTxt] and not Thing.Proxy.Attributes[PropertyTxt].DoNotRenderOtherType) and ReturnFirst(Thing.Proxy.Attributes[PropertyTxt]) or Type

    if Utils.FileExists("Studio/UI/Windows/PropertiesTypes/"..Type..".lua") then
        if not RequiredPropertyTypes[Type] then
            RequiredPropertyTypes[Type] = require("Studio/UI/Windows/PropertiesTypes/"..Type)
        end
        --PropertyTypes[Type](Option,Thing,PropertyTxt) -- make this update if a property was changed, aka for updating positions ect ect ✌️
    else
        --PropertyTypes["Not_Found"](Option,Thing,PropertyTxt)
    end
    
    local BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        Parent = Window,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }
    
    PropertyBased.BaseSquare = Things.Create("Square") { 
        Size = Pivot2D.FromScale(0.95,0.05),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = BaseProperty,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }

    --print(PropertyTxt)

    PropertyBased.PropertyName = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = RequiredPropertyTypes[Type].CustomName or (PropertyTxt or "..."),
        Name = "PropertyName",
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }

    local Option = Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }

    BaseProperty.ListOrder = Index

    RequiredPropertyTypes[Type].Start(Option,Thing,PropertyTxt,BaseProperty)

        if RequiredPropertyTypes[Type].Update then
            RequiredPropertyTypes[Type].ToDisconnect = Thing.PropertyChanged:Connect(function(NewVal,WhatProperty)
                if WhatProperty and WhatProperty == RequiredPropertyTypes[Type].CustomConnect or WhatProperty == PropertyTxt then
                    RequiredPropertyTypes[Type].Update(NewVal)
                end
            end)
        end

    return BaseProperty
end

local function CreateGroup(GroupName,Window)
    local GroupToReturn = {}

    GroupToReturn.IsOpen = true

    local BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Tertiary,
        Layer = 3,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }
    local TextWow = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Name = "GroupNameDisplay",
        Parent = BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }
    local GroupList = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        --BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        BackgroundTransparency = 1,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }

    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = BaseGroup,
    }

    TextWow:SetFont(Studio.Theme.GetCurrentTheme().FontBold)
    Things.Create("ListLayout") {
        Parent = GroupList,
    }

    local function UpdateButton()
        Button:SetImageRect(Rect.new(LineUp_Button[tostring(GroupToReturn.IsOpen)],Vector2.new(64,64)))
    end

    UpdateButton()

    Button.Clicked:Connect(function()
        GroupToReturn.IsOpen = not GroupToReturn.IsOpen

        GroupList:SetVisible(GroupToReturn.IsOpen)

        UpdateButton()
    end)

    function GroupToReturn.ReturnThings()
        return GroupList,BaseGroup
    end

    return GroupToReturn
end

local function DisconnectEverythin()
    for i,v in pairs(RequiredPropertyTypes) do
        if v.ToDisconnect then
            v.ToDisconnect:Disconnect()
            v.ToDisconnect = nil
        end
    end
end

function PropertiesRender.Init()
    local Window = Things.Create("ScrollContainer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Parent =  PropertiesRender.Container,
    }

    local BaseWindow

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        DisconnectEverythin()

        Window:ClearAllChildren()

        BaseWindow = Things.Create("Square") { 
            Size = Pivot2D.FromScale(1,1),
            BackgroundTransparency = 1
        }

        local index = 0
        --[[for Property,v in pairs(Thing.Proxy.Accessible) do
            local Type
            if Thing.Proxy.Types[Property] then Type = Thing.Proxy.Types[Property] end
            print(Property,Type)
            index=index+1
            local Node = CreatePropertyNode(Window,Property,Type,Thing)
            Node.ListOrder = index
        end]]

        for GroupName,v in pairs(Thing.Proxy.Groups) do
            local GroupCreated = CreateGroup(GroupName,BaseWindow)
            local List,Base = GroupCreated.ReturnThings()

            for v,Property in pairs(Thing.Proxy.Groups[GroupName]) do
                local Type
                if Thing.Proxy.Types[Property] then Type = Thing.Proxy.Types[Property] end

                assert(Type, Thing.ClassName.." has improperly defined property "..Property)

                index=index+1
                local Node = CreatePropertyNode(List,Property,Type,Thing,index)
            end
        end
        --Benchmark.End()

        Things.Create("ListLayout") {
            Parent = BaseWindow,
        }

        BaseWindow:SetParent(Window)
    end)

    Studio.Editor3D.OnDeselect:Connect(function(Thing)
        DisconnectEverythin()
        Window:ClearAllChildren()
    end)
end

return PropertiesRender