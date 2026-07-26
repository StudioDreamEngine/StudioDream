local SatisfactoryService = {}

local Words = { -- Who types this shit is Luz im not jokin
    "You look beautiful today!",
    "I love you!",
    "You are awesome!",
    "You look cute today!",
    "Thank you for choosing us!",
    "Yay",
    ":3"
}

function SatisfactoryService.SatisfyMe()
    return Words[math.random(1,#Words)]
end

return SatisfactoryService