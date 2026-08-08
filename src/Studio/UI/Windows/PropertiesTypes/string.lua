local Template = {}

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

local function MapOutForUndo(Table)
    local NewTable = {}
    NewTable.ObjectsToChange = {}
    for i,v in pairs(Table) do 
        table.insert(NewTable.ObjectsToChange,{Property = v.Property,Obj = v.Thing,Val = v.Thing[v.Property]})
    end

    return NewTable
end

function Template.Start(MainInfo)
    local self = {}

    self.SavedFrozen = MapOutForUndo(MainInfo.WillHandle)

    local Text = Studio.Components.CreateStyle("TextInput",{
        ForegroundColor = Studio.CurrentTheme.Text,
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(0.95,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = MainInfo.Option,
    })
    
    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        
        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                Text:SetText(Info.Thing[Info.Property])
            else
                Text:SetText("~")
            end
        end
    end

    table.insert(MainInfo.Connections, Text.FocusEnd:Connect(function() 
        Studio.History.RegisterUndo("LotsOfObjects",self.SavedFrozen)
    end))

    table.insert(MainInfo.Connections, Text.FocusEnd:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            print(Info)
            Runtime.Things.SetProperty(Info.Thing, Info.Property, Text.Text)
        end
        Studio.Layout.CallHandle("Explorer", "Redraw") -- Make this as a attribute thing!!@! 
        
        self.SavedFrozen = MapOutForUndo(MainInfo.WillHandle)
        Studio.History.RegisterUndo("LotsOfObjects",self.SavedFrozen)
    end))

    self.Update()

    return self
end



return Template