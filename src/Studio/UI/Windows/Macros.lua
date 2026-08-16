-- We might let users create these later on, for now, only by devs
local Macros = {}

Macros.Container = nil ---@class Square

Macros.MacroList = {
    ["Reload Resources"] = function()
        Runtime.Resources.ReloadResources()
    end,
    ["Redraw Explorer"] = function()
        --Studio.Layout.CallHandle("Explorer", "Redraw")
    end,
    ["Export Project"] = function()
        Studio.Build.BuildProject()
    end
}

function Macros.Init()
    Studio.Components.CreateStyle("ListLayout",{
        Parent = Macros.Container
    })

    for Name, Macro in pairs(Macros.MacroList) do
        Studio.Components.CreateStyle("TextButton", {
            Size = Pivot2D.FromScale(1,0.2),
            Clicked = Macro,
            Text = Name,
            Parent = Macros.Container
        })
    end
end

return Macros