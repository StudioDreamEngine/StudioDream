local Things = Runtime.Things
local InsertObject = {}

InsertObject.Container = nil ---@class Square
InsertObject.TargetObject = nil

InsertObject.HiperCreated = {}

function InsertObject.Close()
    Studio.Layout.ToggleWindow(InsertObject, false)
end

function InsertObject.CreateHiper(HiperName)
    if not InsertObject.HiperCreated[HiperName] then
        local hiperObject = {}
        hiperObject.MainText = Studio.Components.CreateStyle("Text", {
            Size = Pivot2D.new(1,0,0.15,0),
            Text = HiperName,
            Name = HiperName,
            Parent = InsertObject.ScrollContainer,
            BackgroundTransparency = 1,
            ForegroundColor = "Text"
        })
        hiperObject.ExpandableDropdown = Studio.Components.ExpandableDropdown(hiperObject.MainText, InsertObject.ScrollContainer)

        InsertObject.HiperCreated[HiperName] = hiperObject
        hiperObject.MainText.Dropdown = hiperObject.ExpandableDropdown.Container

        return hiperObject
    else
        return InsertObject.HiperCreated[HiperName]
    end
end

function InsertObject.Init()
    InsertObject.ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{ -- Not a scroll container for now
        Size = Pivot2D.FromScale(1,0.8),
        Position = Pivot2D.FromScale(0,1),
        Pivot = Vector2.new(0,1),
        CanvasSize = Pivot2D.FromScale(1,6),
        Parent = InsertObject.Container,
        Layer = 100,
    })

    --[[InsertObject.CloseButton = Runtime.Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(0.1,0.1),
        Parent = InsertObject.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        BackgroundTransparency = 0,
        BackgroundColor = Studio.CurrentTheme.Outline,
        Layer = 2,
        Resource = "Internal/Studio/Close.png",
        ScaleType = Enum.ScaleType.LockAspect,
    }]]

    InsertObject.SearchBar = Studio.Components.CreateStyle("TextInput",{
        Size = Pivot2D.FromScale(1,0.1),
        Position = Pivot2D.FromScale(0,0.1),
        Pivot = Vector2.new(0,0),
        ForegroundColor = "Text",
        BackgroundTransparency = 0,
        CornerRadius = 8,
        BackgroundColor = "Outline",
        Alignment = Enum.Alignment.Center,
        Parent = InsertObject.Container,
        ClearWhenFocus = true,
        Placeholder = "Search a thing class name!"
    })

    Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/Search.png",
        Parent = InsertObject.SearchBar
    })

    InsertObject.SearchText = ""

    InsertObject.SearchBar.Typed:Connect(function(NewText)
        InsertObject.SearchText = NewText
        InsertObject.UpdateList()
    end)

    InsertObject.SearchBar.FocusEnd:Connect(function()
        InsertObject.SearchText = ""
        InsertObject.UpdateList()
    end)
    --InsertObject.CloseButton.Clicked:Connect(InsertObject.Close)
    Studio.Components.CreateStyle("ListLayout",{
        Parent = InsertObject.ScrollContainer,
        Alignment = Enum.Alignment.TopCenter
    })
    for ClassName, Class in pairs(Runtime.Things.API) do
        if Class.Creatable then
            --print(Class.Category)
            local Hiper = InsertObject.CreateHiper(Class.Category)
            local ToParentWith = Hiper.ExpandableDropdown.Container
            local IconObject = Studio.Components.CreateIconObject(ClassName, Class.ExplorerIcon)

            IconObject:SetPivot(Vector2.zero)
            IconObject:SetSize(Pivot2D.new(1,-20,0,20))
            IconObject.Name = ClassName
            IconObject:SetParent(ToParentWith)
            IconObject.Clicked:Connect(function()
                InsertObject.Close()

                print("Inserting new object: "..ClassName)

                local DefaultTarget = Studio.Editor3D.GetDefaultTarget()

                local CreatedObject = Things.Create(ClassName) {
                    Parent = DefaultTarget,
                }  

                --Studio.Layout.CallHandle("Explorer", "Redraw")

                --[[Studio.Components.CreateDialog(Enum.StudioDialog.Option,{
                    Text = "Are you sure you want to insert "..ClassName.."?",
                    Choices = {
                        {
                            Text = "Yes",
                            OnClick = function()
                                local CreatedObject = Things.Create(ClassName) {
                                    Parent = InsertObject.TargetObject,
                                }  

                                --Studio.Layout.CallHandle("Explorer", "Redraw")
                            end
                        },
                        {
                            Text = "No",
                        },
                    }
                })]]
            end)
        end
    end
end

function InsertObject.UpdateList()
    for _,GroupNode in pairs(InsertObject.ScrollContainer:GetChildren()) do
        if GroupNode.Dropdown then
            for i,v in pairs(GroupNode.Dropdown:GetChildren()) do
                if (v:IsA("Square")) then
                    v:SetVisible((SearchText=='') and true or string.find(v.Name:lower(), InsertObject.SearchText:lower()))
                end
            end
        end
    end
end

--[[function InsertObject.UpdateList()
    for i, v in pairs(InsertObject.ScrollContainer:GetChildren()) do
        if (v:IsA("TextButton")) then
            v:SetVisible((InsertObject.SearchText=='') and true or string.find(v.Name:lower(), InsertObject.SearchText:lower()))
        end
    end
end]]

function InsertObject.Update(dt)
    
end

return InsertObject