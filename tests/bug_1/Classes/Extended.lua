---@module 'Thing'
local Extended = require("Classes.Thing"):extend()

function Extended:new() 
    Extended.super.new(self)
end

return Extended