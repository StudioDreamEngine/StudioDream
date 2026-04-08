---@module 'Thing'
local Extended = Things.Extend("Extended")

function Extended:new() 
    Extended.super.new(self)

    print("i am extended2")
end

return Extended