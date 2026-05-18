local GeneratedList
local ChangedOption = Signal:New("BlehBleh")

-- Creates the list of Enums for the dropdown
local function GenerateList(Option,Frame,Thing)
    local Enum = Enum[Option]
    local Index = 0
    local Choices = {}

    for i,v in pairs(Enum) do
        if i ~= "Type" or i ~= "NameFromValue" then
            Index=Index+1

            table.insert(Choices,{
                Text = tostring(i),
                Function = function()
                    Thing[Option] = v
                    ChangedOption.Invoke()
                    GeneratedList:RemoveDropdown()
                end
            })
        end
    end

    GeneratedList = Studio.Components.ShowDropdown(Frame,Choices,Vector2.new(100,10),true)
end

local Size = Vector2.new(64,64)
local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local function ChangeButton(But,Property)
    But:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
end

return function(FrameOption,Thing,Property) 
    local EnumLock = false
    local ConnectFunction
    
    local TextClick = Runtime.Things.Create("TextButton") {
        Text = tostring(Utils.GetEnumNameByValue(Property,Thing[Property])),
        ForegroundColor = Studio.Theme.Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = FrameOption
    }

    local Button = Runtime.Things.Create("Image2D") {
        Image = "Assets/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = TextClick,
    }

    ChangeButton(Button,EnumLock)

    TextClick.Clicked:Connect(function()
        print(EnumLock)

        if not ConnectFunction then
            ConnectFunction = ChangedOption:Connect(function()
                print("Bleh")
                TextClick.Text = tostring(Utils.GetEnumNameByValue(Property,Thing[Property]))
                EnumLock = false
                ChangeButton(Button,EnumLock)
            end)
        end

        EnumLock = not EnumLock
        ChangeButton(Button,EnumLock)

        if EnumLock then
            GenerateList(Property,FrameOption,Thing)
        else
            if (not GeneratedList) then return end -- Guard Clauses mikl! Guard clauses
            
            GeneratedList.RemoveDropdown()
        end
    end)

end