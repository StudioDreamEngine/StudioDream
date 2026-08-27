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
    "This releases on Winter 2014!"
}

function SatisfactoryService.SatisfyMe()
    return Words[math.random(1,#Words)]
end

return SatisfactoryService