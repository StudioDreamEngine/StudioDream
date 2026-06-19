local Trollo = {}
local Things = Runtime.Things
function Trollo.Init()
    local ThingWow = Things.Create("TextButton") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Text = "Generate a game for me pls pls",
        BackgroundTransparency = 1,
        Parent =  Trollo.Container,
    }
    ThingWow:SetText("Generate a game for me pls pls")
    ThingWow.Clicked:Connect(function()
        love.window.showMessageBox("LOLLLLLLLLLLLLL", "What is VRO doin", "warning")
        love.window.showMessageBox("LOLLLLLLLLLLLLL", "We dont have an AI bro 😭😭😭💀💀", "error")
        love.window.showMessageBox("LOLLLLLLLLLLLLL", "Stop bein a lazy ass and do your own stuff 🙄", "error")
    end)
end

return Trollo