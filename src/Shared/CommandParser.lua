-- Parse command line args
local Switches = {
    Verbose = {
        Type = "Switch",
        Flag = "Verbose"
    },
    Target = {
        Type = "String",
        Flag = "Target",
        Valid = {"Client", "Studio"}
    },
    DebugDraw = {
        Type = "Switch",
        Flag = "DebugDraw"
    },
    DisableExternalOutput = {
        Type = "Switch",
        Flag = "!ExternalOutput"   
    },
    SecondRun = {
        Type = "Switch",
        Flag = "SecondRun"
    },
    Independent = {
        Type = "Switch",
        Flag = "Independent"
    },
    Help = {
        Type = "Switch",
        Output = function()
            return [[
            
HELP
    USAGE: StudioDream [PROJECT?] [OPTIONS]

    Options (Specify with "--"):
        Help: Show this screen
        SecondRun: Disables intro animation + studio welcome screen
        DisableExternalOutput: Disable any output through _G.PrintCallback (Also disables Output Window)
        Target [MODE]: The target mode to run, available targets are "Studio" and "Client"
        Verbose: If to enable more verbose prints (THESE WILL NOT BE LOGGED TO THE STUDIO OUTPUT!)
        DebugDraw: If to enable the debug drawing renderers
        Independent: Treat this as a project that isnt tied to StudioDream
            ]]
        end
    },
    PLEASEHELPLUZ = {
        Type = "Switch",
        Output = function()
            return [[
                Okay damn calm down, idk how this works but bloctans said u can use the "Help" command
                to well, help u
            ]]
        end
    }
}

local function HandleSwitch(Arg, NextArg)
    local Config = Switches[Arg] or {}
    local FlagName = Config.Flag

    if Config.Type == "Switch" then
        if Config.Output then return Config.Output() end
        local IsInverse = (string.sub(FlagName,1,1) == "!")
        local FlagValue = (not IsInverse)

        if IsInverse then FlagName = string.sub(FlagName,2,-1) end

        FLAGS[FlagName] = FlagValue
    elseif Config.Type == "String" then
        local IsValid = true

        if Config.Valid then IsValid = table.find(Config.Valid, NextArg) end
        
        if IsValid then
            FLAGS[FlagName] = NextArg
        else
            return "Invalid "..FlagName.." \""..NextArg.."\""
        end
    else
        return "Invalid Switch \""..Arg.."\""
    end
end

-- Ex. StudioDream --ProjectFile ./tests/ProjectTest --Verbose --Target Client
return function(Args)
    for Index, Arg in pairs(Args) do
        local NextArg = Args[Index + 1]
        local IsSwitch = (string.sub(Arg, 1,2) == "--")

        if (Index == 1) and (not IsSwitch) then -- Project
            FLAGS.TargetProject = Arg
        elseif IsSwitch then
            Arg = string.sub(Arg,3,-1)

            local Error = HandleSwitch(Arg, NextArg)
            if Error then return Error end
        end
    end
end