local Things = {}

function Things.Init()
    local Parent = require("Classes.Extended")()

    local Test = require("Classes.Extended")()
    Test.Name = "SquareTest"
    Test:AddChild(Parent)

    print_table(Parent.Children)

    local Test2 = require("Classes.Extended")()
    Test2.Name = "SquareTest2"
    Test2:AddChild(Parent)

    print_table(Parent.Children)
end

return Things