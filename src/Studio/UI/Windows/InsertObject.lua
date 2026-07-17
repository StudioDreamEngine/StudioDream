local Things = Runtime.Things
local InsertObject = {}

InsertObject.Container = nil ---@class Square
InsertObject.TargetObject = nil

function InsertObject.Close()
    Studio.Layout.ToggleWindow(InsertObject, false)
end

function InsertObject.Init()
    InsertObject.ScrollContainer = Things.Create("ScrollContainer") { -- Not a scroll container for now
        Size = Pivot2D.FromScale(1,0.9),
        Position = Pivot2D.FromScale(0,1),
        Pivot = Vector2.new(0,1),
        CanvasSize = Pivot2D.FromScale(1,3),
        Parent = InsertObject.Container,
        Layer = 100
    }

    InsertObject.SearchBar = Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,0.1),
        Position = Pivot2D.FromScale(0,0),
        Pivot = Vector2.new(0,0),
        --ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundColor = Studio.Theme.CurrentTheme.Secundary,
        OutlineColor = Studio.Theme.CurrentTheme.Outline,
        OutlineSize = 2,
        CornerRadius = 5,
        Parent = InsertObject.ScrollContainer,
    }

    InsertObject.SearchText = ""

    InsertObject.SearchBar.Typed:Connect(function(NewText)
        InsertObject.SearchText = NewText
        InsertObject.UpdateList()
    end)

    for ClassName, Class in pairs(Runtime.Things.API) do
        if Class.Creatable then
            local IconObject = Studio.Components.CreateIconObject(ClassName, Class.ExplorerIcon)

            IconObject:SetPivot(Vector2.zero)
            IconObject:SetSize(Pivot2D.new(-20,1,20,0))
            IconObject.Name = ClassName
            IconObject:SetParent(InsertObject.ScrollContainer)
            IconObject.Clicked:Connect(function()
                InsertObject.Close()

                local DefaultTarget = Studio.Editor3D.GetDefaultTarget()

                local CreatedObject = Things.Create(ClassName) {
                    Parent = InsertObject.TargetObject or DefaultTarget,
                }  

                Studio.Layout.CallHandle("Explorer", "Redraw")

                --[[Studio.Components.CreateDialog(Enum.StudioDialog.Option,{
                    Text = "Are you sure you want to insert "..ClassName.."?",
                    Choices = {
                        {
                            Text = "Yes",
                            OnClick = function()
                                local CreatedObject = Things.Create(ClassName) {
                                    Parent = InsertObject.TargetObject,
                                }  

                                Studio.Layout.CallHandle("Explorer", "Redraw")
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

    Things.Create("ListLayout") {
        Parent = InsertObject.ScrollContainer,
        Alignment = Enum.Alignment.TopRight
    }
end

function InsertObject.UpdateList()
    for i, v in pairs(InsertObject.ScrollContainer:GetChildren()) do
        if (v:IsA("TextButton")) then
            v:SetVisible((InsertObject.SearchText=='') and true or string.find(v.Name:lower(), InsertObject.SearchText:lower()))
        end
    end
end

function InsertObject.Update(dt)
    
end

return InsertObject