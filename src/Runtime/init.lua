local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Resources = require("Runtime.Resources")
Runtime.Renderer = require("Runtime.Renderer")

Runtime.LoadProjectCallback = function() end

function Runtime.Init()
    Profiler.Init()
    Platform.Init("StudioDream")

    Runtime.Shaders = Runtime.Renderer.GetShaders()
    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Resources.Init()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    -- init WindowManager here, as doing it in PostInit can fuck up the splash screen and resizing routines (for some reason)
    --Runtime.WindowManager = require("Runtime.Backend.WindowManager")
    --Runtime.WindowManager.Init()

    printVerbose("Runtime Initalized")
end

function Runtime.ChangeTitle()
    love.window.setTitle(string.format("StudioDream %s - %s (%s)", VERSION_FULL, Runtime.Project.Config.Get("Name"), Shared.Target))
end

function Runtime.RequestRestart(NextTarget)
    local Benchmark = Profiler.Benchmark("Restart StudioDream", true)

    Dream:requestKill(function()
        Benchmark.End()
        love.event.restart({
            Runtime.ProjectFS.GetMount(),
            "--Target",
            NextTarget,
            "--SecondRun"
        })
    end)
end

function Runtime.PostInit()
    Runtime.Backend = require("Runtime.Backend")
    Runtime.Backend.Init()

    Runtime.SettingsManager = require("Runtime.SettingsManager")
    Runtime.SettingsManager.Init()

    Runtime.Things.CreateApiDump()

    Dream:prepareRuntime()
    Runtime.Backend3D.SetupDebug()

    Runtime.Project = require("Runtime.Project")
    Runtime.Things.CreateEnviornment()

    print("Finished PostInit")
end

-- runs after the target is initalized
function Runtime.PostTarget(ProjectPath)
    printVerbose("Loading project:",ProjectPath)

    if ProjectPath then
        Runtime.Project.Load(ProjectPath)
    else
        Runtime.Project.LoadDefault()
    end
end

function Runtime.Render()
    Runtime.Renderer.Render()
    Dream:presentDebug()
end

function Runtime.Update(dt)
   -- Runtime.WindowManager.Update(dt)

    if Runtime.Backend then
        Runtime.Backend.Update(dt)
    end

    Runtime.Renderer.ViewportManager.Update(dt) -- temporary
    Runtime.Things.Update(dt)
end

function Runtime.OnCrash()
    local Path = Platform.GetDocuments().."/Recovery"

    NativeFS.createDirectory(Path)
    Runtime.Project.SaveTo(Path)
end

return Runtime