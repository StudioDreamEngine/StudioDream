local DialogWindows = {}
local Components = Studio.Components
local Tween = Runtime.Services.Service("TweenService")

local DialogFade = Runtime.Things.Create("Square") {
    Size = Pivot2D.FromScale(1,1),
    Layer = 998,
    Parent = Runtime.Things.GetRootViewport(),
    BackgroundTransparency = 0.5,
    BackgroundColor = Color.new(0),
    Visible = false
}
local ActiveDialogWindow

local function ToggleAnim()
    local CurrentDropdown = ActiveDialogWindow
    local IsTrue = false
    if CurrentDropdown then
        CurrentDropdown = CurrentDropdown.Window
        for i,v in pairs(CurrentDropdown:GetDescendants()) do
        if v.ClassName ~= "ListLayout" then 
            
        end
    end
    for i,v in pairs(CurrentDropdown:GetDescendants()) do
        if v.ClassName ~= "ListLayout" then 
            
        end
      --  CurrentDropdown.Visible = IsTrue
    end
    Scheduler.Yield(.1)
    CurrentDropdown:SetVisible(IsTrue)    
        
    end
end

function DialogWindows.DestroyDialogWindow()
    ToggleAnim()
    if ActiveDialogWindow then
        Components.UnregisterUpdator(ActiveDialogWindow.Updator)

        ActiveDialogWindow.Window:Destroy()
        ActiveDialogWindow = nil
    end
    DialogFade:SetVisible(false)
end

function DialogWindows.CreateDialogWindow(Type, Options)
    DialogWindows.DestroyDialogWindow()
    DialogFade:SetVisible(true)

    local ModuleDialog = require("Studio.UI.Components.Dialog."..Type)
    local DialogObject = ModuleDialog(Options)

    DialogObject.Window = Runtime.Things.Create("Square") { 
        Size = Pivot2D.FromScale(0.4,0.3),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.Secondary,
        Name = "WindowContainer",
        Layer = 999,
        Parent = Runtime.Things.GetRootViewport(),
        CornerRadius = 5,
        OutlineSize = 5,
        OutlineColor = Studio.Theme.Outline
    }
    
    DialogObject.Container = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.99,0.99) ,
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = DialogObject.Window,
        CornerRadius = 2.5,
    }

    DialogObject.Close = DialogWindows.DestroyDialogWindow
    DialogObject.Updator = Components.RegisterUpdator(DialogObject.Update)

    DialogObject.CreateDialog()
    ActiveDialogWindow = DialogObject
end

return DialogWindows