
local PropertiesRender = {}
local Things = Runtime.Things
local RequiredPropertyTypes = {}

local LineUp_Button = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local function CreatePropertyNode(Window,PropertyTxt,Type,Thing,Index)
    local BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.Secondary,
        Layer = 3,
        Parent = Window,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.Outline
    }
    
    Things.Create("Square") { 
        Size = Pivot2D.FromScale(0.95,0.05),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Parent = BaseProperty,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.Outline
    }

    Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyTxt,
        Name = "PropertyName",
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text
    }

    local Option = Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }
    BaseProperty.ListOrder = Index
    if Utils.DoesFileExist("Studio/UI/Windows/PropertiesTypes/"..Type..".lua") then
        if not RequiredPropertyTypes[Type] then
            RequiredPropertyTypes[Type] = require("Studio/UI/Windows/PropertiesTypes/"..Type)
        end
        RequiredPropertyTypes[Type](Option,Thing,PropertyTxt,BaseProperty)
        --PropertyTypes[Type](Option,Thing,PropertyTxt) -- make this update if a property was changed, aka for updating positions ect ect ✌️
    else
        --PropertyTypes["Not_Found"](Option,Thing,PropertyTxt)
    end

    return BaseProperty
end

local function CreateGroup(GroupName,Window)
    local GroupToReturn = {}

    GroupToReturn.IsOpen = true

    local BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.Tertiary,
        Layer = 3,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.Outline
    }
    local TextWow = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Name = "GroupNameDisplay",
        Parent = BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text
    }
    local GroupList = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        --BackgroundColor = Studio.Theme.Secondary,
        Layer = 3,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.Outline
    }
    local Button = Runtime.Things.Create("ImageButton") {
        Image = "Assets/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Studio.Theme.Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = BaseGroup,
    }
    TextWow:SetFont("Assets/Fonts/Roboto/Roboto-Bold.ttf")
    Things.Create("ListLayout") {
        Parent = GroupList,
    }

    local function UpdateButton()
        Button:SetImageRect(Rect.new(LineUp_Button[tostring(GroupToReturn.IsOpen)],Vector2.new(64,64)))
    end

    UpdateButton()

    Button.Clicked:Connect(function()
        GroupToReturn.IsOpen = not GroupToReturn.IsOpen
        GroupList.Visible = GroupToReturn.IsOpen
        UpdateButton()
    end)

    function GroupToReturn:ReturnThings()
        return GroupList,BaseGroup
    end

    return GroupToReturn
end

function PropertiesRender.Init()
    local Window = PropertiesRender.Container --[[Things.Create("ScrollContainer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundColor = Studio.Theme.Secondary,
        Parent =  PropertiesRender.Container,
    }]]

    local BaseWindow

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        print("Clear")
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
            local List,Base = GroupCreated:ReturnThings()
            for v,Property in pairs(Thing.Proxy.Groups[GroupName]) do
                local Type
                if Thing.Proxy.Types[Property] then Type = Thing.Proxy.Types[Property] end
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

    Studio.Editor3D.OnDeselect:Connect(function()
        Window:ClearAllChildren()
    end)
end

return PropertiesRender