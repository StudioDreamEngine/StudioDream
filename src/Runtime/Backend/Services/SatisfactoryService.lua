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
    "No sorrey"
}

function SatisfactoryService.SatisfyMe()
    return Words[math.random(1,#Words)]
end

return SatisfactoryService