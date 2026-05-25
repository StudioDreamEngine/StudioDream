local Profiler = {}

local DeltonInstance

function Profiler.Init()
    DeltonInstance = Dream.delton
end

function Profiler.Benchmark(Name, AlertStart)
    local Benchmark = {}

    local Start = os.clock()

    if AlertStart then
        print("Starting Benchmark: "..Name)
    end

    function Benchmark.End()
        local Diff = os.clock() - Start

        print("Completed Benchmark: "..Name.." in "..tostring(Diff*1000).."ms")
    end

    return Benchmark
end

function Profiler.Start(Name)
    DeltonInstance:start(Name)
end

function Profiler.EndStart(Name)
    DeltonInstance:stop()
    DeltonInstance:start(Name)
end

function Profiler.End()
    DeltonInstance:stop()
end

function Profiler.Present()
    DeltonInstance:present()
end

function Profiler.Render()
    DeltonInstance:step()
end

return Profiler