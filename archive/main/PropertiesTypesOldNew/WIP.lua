local Template = {}

function Template.Start(MainInfo)
    local self = {}

    MainInfo.Option.BackgroundTransparency = 1
    MainInfo.Text:SetText("This Thing is still super wip and the stuff here doesnt actually work")

   
    return self
end

return Template