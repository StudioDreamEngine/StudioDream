---@module 'Thing'
local Extended = Things.Extend("Thing")

function Extended:new() 
    Extended.super.new(self)

    print("Check is thing")
    print(Extended:is(require("Classes.Thing")))
end

return Extended