-- We might let users create these later on, for now, only by devs
return function(Macros)
    Macros.MacroList = {
        ["Reload Resources"] = function()
            Runtime.Resources.ReloadResources()
        end,
        ["Redraw Explorer"] = function()
            Runtime.Things.RequestTreeChange()
        end,
        ["Export Project"] = function()
            Studio.Build.BuildProject()
        end,
        ["STRESS TEST - ui objects"] = function()
            local Objects = {}
            local Bench = Profiler.Benchmark("Create 500 text objects")

            for i = 0,500 do
                table.insert(Objects, Runtime.Things.Create("Text") {
                    Parent = Runtime.Things.RenderRoot,
                    Name = i
                })
            end
            Bench.End()

            local Bench2 = Profiler.Benchmark("Destroy all")
            for _, object in pairs(Objects) do
                object:Destroy()
            end

            table.clear(Objects)
            Bench2.End()
        end
    }

    function Macros.Init()
        Studio.Components.CreateStyle("ListLayout",{
            Parent = Macros.Container
        })

        for Name, Macro in pairs(Macros.MacroList) do
            Studio.Components.CreateStyle("TextButton", {
                Size = Pivot2D.FromScale(1,0.1),
                Clicked = Macro,
                Text = Name,
                Parent = Macros.Container
            })
        end
    end

    return Macros
end