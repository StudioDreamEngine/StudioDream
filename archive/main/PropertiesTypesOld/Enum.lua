local Enumed = {}

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
                Type = "Button",
                Function = function()
                    Thing[Option] = v
                    ChangedOption.Invoke()
                    GeneratedList = nil
                end
            })
        end
    end

    GeneratedList = Studio.Components.AdvancedDropdown(Choices)
    GeneratedList.Setup(Frame, Vector2.new(0,1))
    GeneratedList.Toggle(true)
end

local Size = Vector2.new(64,64)
local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local function ChangeButton(But,Property)
    But:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
end

function Enumed.Start(FrameOption,Thing,Property) 
    local EnumLock = false
    local ConnectFunction
    
    local TextClick = Runtime.Things.Create("TextButton") {
        Text = tostring(Utils.GetEnumNameByValue(Property,Thing[Property])),
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        CornerRadius=5
    }

    local Button = Runtime.Things.Create("Image2D") {
        Resource = "Internal/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Text,
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
            
            GeneratedList = nil
        end
    end)

end

return Enumed