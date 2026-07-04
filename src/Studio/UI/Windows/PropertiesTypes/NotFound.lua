local Template = {}



function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections

    local Text = Runtime.Things.Create("Text") {
        Text = "WIP!",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    for i,Info in pairs(MainInfo.WillHandle) do
        Text:SetText("WIP! ("..Info.Thing.Proxy.Types[Info.Property]..")")
    end
    function self.Update()

    end

    return self
end

return Template