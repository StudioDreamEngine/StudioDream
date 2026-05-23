local SelectionThing = {}
local Things = Runtime.Things

local Editor3D
local ToolManager
local LastSelection    

SelectionThing.IsGetObjToPutOnVal = false

SelectionThing.GetObjOnVal = Signal:New("GetThingToPutOnAProperty")

function SelectionThing.GetObjToFalse()
    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
    SelectionThing.IsGetObjToPutOnVal = false
end

local function DeselectThing()
    if Editor3D.Selecting then -- 💀💀💀💀💀
        if Editor3D.Selecting.SetOutline then Editor3D.Selecting:SetOutline(false) end
        local Tree = Studio.Layout.GetWindow("Explorer").Tree
        local ObjNode = Tree[Editor3D.Selecting]
        if ObjNode then ObjNode:SetBackgroundColor(Studio.Theme.Secondary) end
        -- Editor3D.OnDeselect.Invoke()
    end
    SelectionThing.GetObjToFalse()
    ToolManager.Deselect()
end

function SelectionThing.StartGrabToPutOnValue()
    SelectionThing.IsGetObjToPutOnVal = true
    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/HoldingObj.png", 0,0))
    return SelectionThing.GetObjOnVal
end

function SelectionThing.SelectThing(Thing)
    if LastSelection~=Thing then
        DeselectThing()
    end

    if not SelectionThing.IsGetObjToPutOnVal then
        Editor3D.Selecting = Thing
        
        if Editor3D.Selecting.SetOutline then
            Editor3D.Selecting:SetOutline(true)
        end

        LastSelection = Editor3D.Selecting

        ToolManager.Select(Editor3D.Selecting)
        Editor3D.OnSelect.Invoke(Editor3D.Selecting)

        local Tree = Studio.Layout.GetWindow("Explorer").Tree
        local ObjNode = Tree[Thing]
        if ObjNode then  
            ObjNode:SetBackgroundColor(Studio.Theme.Selecting)
        end
    else
        SelectionThing.GetObjOnVal.Invoke(Thing)
        SelectionThing.GetObjToFalse()
    end
end

function SelectionThing.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager

    SelectionPriority.BindSignal(function(IsDown)
        if (not IsDown) then return end

        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment.Camera ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if Raycast and Raycast.OnViewport then -- IF STATEMENTS CHAOS!! AHHHH!!
            SelectionThing.SelectThing(Raycast.Thing)
        elseif Raycast and (not Raycast.OnViewport) then-- 💀💀💀💀💀
            return
        else
            DeselectThing()
        end
    end, 1)
end

return SelectionThing