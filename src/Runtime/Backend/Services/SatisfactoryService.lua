local SatisfactoryService = {}

local Words = { -- Who types this shit is Luz im not jokin
    "You look beautiful today!",
    "I love you!",
    "You are awesome!",
    "You look cute today!",
    "Thank you for choosing us!",
    "Yay",
    ":3",
    "You renewed your Studio Dream Trial!",
    "Put that shit on fire",
    "Yo luz can you stop writing bs?",
    "No sorrey",
    "Your doing awesome!",
    "Great work!",
    "yay (Reverb version)",
    "You know what is delta right?",
    "Delta time or that one game?",
    "Root:Destroy()",
    "Root:Heal()",
    "Five stars to your project!",
    "BlehBlehBelh",
    "Limbombom",
    "I bet someone makes a project and exports to an ###",
    "This releases on Winter 2014!",
    "This will be studiodream in 2017- oh my god its almost been 10 years"
}

function SatisfactoryService:SatisfyMe()
    return Words[math.random(1,#Words)]
end

function SatisfactoryService.Init() end

function SatisfactoryService:InfuriateMe()
    for _, Object in pairs(Runtime.Things.GetObjects()) do
        if math.random(0,4) == 2 then
            Object:Destroy()
            return
        end
    end
end

function SatisfactoryService:ColonThreeify()
    local RealPrintOG = PrintOG
    local Endings = {":3", ">_<", "^_^", "OmO"}
    local EndingSad = {"3:", ">_<",":C"}

    PrintOG = function(Final)
        local lower = string.lower(Final)
        local ending

        if string.find(lower, "failed") or string.find(lower, "error") or string.find(lower, "not") then
            ending = EndingSad[math.random(1,#EndingSad)]
        else
            ending = Endings[math.random(1,#Endings)]
        end

        RealPrintOG(string.gsub(Final, "[rR]", "w").." "..ending)
    end

    print(":3 mode activated")
end

return SatisfactoryService