local Things = {}

function Things.Type(ThingType) return require("Classes."..ThingType) end
function Things.Extend(ThingType) return Things.Type(ThingType):extend() end

function Things.Init()
    local Parent = Things.Type("Extended2")

    local Test = Things.Type("Extended")
    Test.Name = "SquareTest"
    Test:AddChild(Parent)

    Print_table(Parent.Children)

    local Test2 = Things.Type("Extended")
    Test2.Name = "SquareTest2"
    Test2:AddChild(Parent)

    Print_table(Parent.Children)
end

return Things