---@module 'Thing'
local Extended = require("Classes.Thing"):extend()

function Extended:new() 
    Extended.super.new(self)

    print("Check is thing")
    print(Extended:is(require("Classes.Thing")))
end

return Extended