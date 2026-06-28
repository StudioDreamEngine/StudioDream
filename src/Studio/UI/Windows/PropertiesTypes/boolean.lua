local Bool = {}

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(128,0),
    ["nil"] = Vector2.new(0,0)
}

local function UpdateButton(Property,Button)
    Button:SetImageRect(Rect.new(LineUp[tostring(Property)],Vector2.new(64,64)))
end

local function CheckAllTheSame(table)
    local FirtaVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirtaVal then
            return false
        end
    end
    return true
end

function Bool.Start(MainInfo)
    local self = {}

    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Studio/Boolean.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = MainInfo.Option,
    }

    function self.Update()
        for i,Info in pairs(MainInfo.WillHandle) do
            UpdateButton(Info.Thing[Info.Property],Button)
        end
    end
    self.Update()
    
    table.insert(MainInfo.Connections, Button.Clicked:Connect(function()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        local NotSameSwitch = MainInfo.WillHandle[1].Property

        for i, Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                local CurrentVal = Info.Thing[Info.Property]
                Runtime.Things.SetProperty(Info.Thing, Info.Property, (not CurrentVal))
            else
                Runtime.Things.SetProperty(Info.Thing, Info.Property, (not NotSameSwitch))
            end
        end

        if AllSame then
            local NewVal = MainInfo.WillHandle[1].Thing[MainInfo.WillHandle[1].Property]
            UpdateButton(NewVal, Button)
        else
            UpdateButton(nil, Button)
        end

    end))

    return self
end

return Bool