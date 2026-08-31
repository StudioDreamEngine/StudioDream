local Profiler = {}

function Profiler.Init()
    
end

function Profiler.Benchmark(Name, AlertStart)
    local Benchmark = {}

    local Start = os.clock()

    if AlertStart then
        printVerbose("Starting Benchmark: "..Name)
    end

    function Benchmark.End()
        local Diff = os.clock() - Start

        printVerbose("Completed Benchmark: "..Name.." in "..tostring(Diff*1000).."ms")
    end

    return Benchmark
end

function Profiler.Start(Name)
    if Profiler.Frame then
        Jprof.push(Name)
    end
end

function Profiler.EndStart(Name)
    if Profiler.Frame then
        Jprof.pop()
        Jprof.push(Name)
    end
end

function Profiler.End(Name)
    if Profiler.Frame then
        Jprof.pop(Name)
    end
end

function Profiler.Render()
    Dream.delton:present()
end

function Profiler.Quit()
    Jprof.write("prof.mpack")
end

return Profiler