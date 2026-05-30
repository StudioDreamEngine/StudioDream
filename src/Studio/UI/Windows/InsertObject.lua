local Things = Runtime.Things
local InsertObject = {}

InsertObject.Container = nil ---@class Square

function InsertObject.Init()
    InsertObject.ScrollContainer = Things.Create("Square") { -- Not a scroll container for now
        Size = Pivot2D.FromScale(1,1),
        Parent = InsertObject.Container
    }

    for ClassName, Class in pairs(Runtime.Things.API) do
        if Class.Creatable then
            local IconObject = Studio.Components.CreateIconObject(ClassName, Class.ExplorerIcon)

            IconObject.Pivot = Vector2.zero
            IconObject.Size = Pivot2D.new(-20,1,20,0)
            IconObject:SetParent(InsertObject.ScrollContainer)
            IconObject.Clicked:Connect(function()
                Studio.Components.CreateOptionWindow("Are you sure you want to insert "..ClassName.."?",{
                    {
                        Text = "Yes",
                        OnClick = function()
                            Things.Create(ClassName) {
                                Parent = Things.GetRoot("Environment"),
                               
                            }
                             Studio.Layout.CallHandle("Explorer", "Redraw")
                        end
                    },
                    {
                        Text = "No"
                    },
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