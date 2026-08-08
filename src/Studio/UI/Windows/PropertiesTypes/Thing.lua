local Template = {}

local SelectionManager = Studio.Editor3D.SelectionManager

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
    NewTable.SpecialFunction = function()
        Studio.Layout.CallHandle("Explorer", "Redraw")
    end
    for i,v in pairs(Table) do 
        table.insert(NewTable.ObjectsToChange,{Property = v.Property,Obj = v.Thing,Val = v.Thing[v.Property]})
    end

    return NewTable
end

function Template.Start(MainInfo)
    local self = {}

    self.SavedFrozen = MapOutForUndo(MainInfo.WillHandle)

    local Button = Studio.Components.CreateStyle("TextButton",{
        ForegroundColor = Studio.CurrentTheme.Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.CurrentTheme.FontBold,
        BackgroundColor = Studio.CurrentTheme.Primary,
        CornerRadius = 5,
    })

    local Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(1,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/EditorIcons/Drawable3D.png",
        Parent = Button
    })
    --print(MainInfo)

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        for i,Info in pairs(MainInfo.WillHandle) do
            --print(Info)
            if AllSame then
                Button:SetText(Info.Thing[Info.Property] and Info.Thing[Info.Property].Name or "~")
                Image:SetResource(Info.Thing[Info.Property] and "Internal/Studio/EditorIcons/"..Info.Thing[Info.Property].Proxy.ExplorerIcon..".png" or "Internal/Studio/EditorIcons/Drawable3D.png")
            else
                Button:SetText("~")
                Image:SetResource("Internal/Studio/EditorIcons/Drawable3D.png")
            end
        end
    end

    self.Update()
    
    table.insert(MainInfo.Connections,Button.Clicked:Connect(function()
        local Registrated = Studio.History.RegisterUndo("LotsOfObjects",self.SavedFrozen)
        for i,Info in pairs(MainInfo.WillHandle) do
            if not SelectionManager.ObjectPicker then
                SelectionManager.ObjectPicker = Info.Thing
                Runtime.Cursor.ChangeCursor("HoldingObj")

                SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                    Runtime.Things.SetProperty(Info.Thing, Info.Property, NewThing)
                    Studio.Layout.CallHandle("Explorer", "Redraw")
                end)
                self.SavedFrozen = MapOutForUndo(MainInfo.WillHandle)
                Studio.History.RegisterUndo("LotsOfObjects",self.SavedFrozen)
            else
                SelectionManager.ObjectPicker = false
                Runtime.Cursor.ChangeCursor("Main")
                Registrated:Cancel()
            end
        end
        self.Update()
    end))

    return self
end

return Template