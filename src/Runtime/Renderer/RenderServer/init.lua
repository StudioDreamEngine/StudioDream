-- Manages immediate mode for an object
---@class RenderServer
local RenderServer = {}
local RenderClient = require("Runtime.Renderer.RenderServer.RenderClient")

local ServerPath = "Runtime.Renderer.RenderServer."

--[[
    Immediate mode for now will only support basic Squares and images

    Also, as much as i'd wanna rewrite the square and image to take more advantage of immediate mode, i feel like
    the extra complexity with getting those to work with the entire rendering thing will make performance WORSE

    The idea is that you can bind an immediate-mode function to a viewport object
    we will be using classic objects for EVERYTHING here
    
    local 
    
    Viewport:SetupImmediateMode(function(RenderClient)
        RenderClient.
    end)
    
    KEEP IN MIND: Retained-mode objects will render after any immediate mode object, this is a limitation with how this will be handled
]]

function RenderServer.CreateClient(Viewport, Function)
    local ClientInstance = RenderClient()
    ClientInstance:new(Viewport, RenderServer, Function)
    return ClientInstance
end

function RenderServer.GetRenderer(Name)
    return require(ServerPath.."Renderers."..Name)
end

-- Create an object, the purpose of these are to hold INFORMATION, and can be used ACROSS draws
function RenderServer.CreateObject(Name, ...)
    local Instance = require(ServerPath.."Objects."..Name)()
    Instance:new(...)
    return Instance
end

return RenderServer