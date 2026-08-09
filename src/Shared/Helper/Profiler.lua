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
    Jprof.push(Name)
end

function Profiler.EndStart(Name)
    Jprof.pop()
    Jprof.push(Name)
end

function Profiler.End()
    Jprof.pop()
end

function Profiler.Quit()
    Jprof.write("prof.mpack")
end

return Profiler