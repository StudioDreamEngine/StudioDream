---@module 'Thing'
local Extended = require("Classes.Thing"):extend()

function Extended:New() 
    self.super:New()
end

return Extended