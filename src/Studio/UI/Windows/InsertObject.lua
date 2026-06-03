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
        Parent = InsertObject.Container,
        Layer = 100
    }

    InsertObject.SearchBar = Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,0.1),
        Position = Pivot2D.FromScale(0,0),
        Pivot = Vector2.new(0,0),
        Parent = InsertObject.ScrollContainer,
        ForegroundColor = Studio.Theme.Text,
        BackgroundColor = Studio.Theme.Secundary,
        OutlineColor = Studio.Theme.Outline,
        OutlineSize = 2,
    }

    InsertObject.SearchBar.Typed:Connect(function(NewText)
        
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

                Studio.Components.CreateDialog(Enum.StudioDialog.Option,{
                    Text = "Are you sure you want to insert "..ClassName.."?",
                    Choices = {
                        {
                            Text = "Yes",
                            OnClick = function()
                                Things.Create(ClassName) {
                                    Parent = InsertObject.TargetObject,
                                }

                                Studio.Layout.CallHandle("Explorer", "Redraw")
                            end
                        },
                        {
                            Text = "No",
                        },
                    }
                })
            end)
        end
    end

    Things.Create("ListLayout") {
        Parent = InsertObject.ScrollContainer,
        Alignment = Enum.Alignment.TopRight
    }
end

function InsertObject.Update(dt)
    
end

return InsertObject