local Stringed = {}
local Stringthing

local function FormatTime(Time)
    local totalSeconds = Time or 0

	local minutes = math.floor(totalSeconds / 60)
	local seconds = totalSeconds % 60
	
	return string.format("%d:%02d", minutes, seconds)
end

function Stringed.Start(FrameOption,Thing,Property) 
    Stringthing = Runtime.Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,1),
        Text = FormatTime(Thing[Property]),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text2,
        Parent = FrameOption
    }

    Stringthing.FocusEnd:Connect(function() -- not done :heart:
        --[[Studio.EditorServices.Undo.RegisterUndo(Thing,Property,Thing[Property])
        Thing[Property] = Stringthing.Text
        --print(Studio.Layout.WindowsCreated)

        Studio.Layout.CallHandle("Explorer", "Redraw") -- Change this pls :skull:]]
    end)
end

function Stringed.Update(NewVal)
    Stringthing:SetText(FormatTime(NewVal))
end

return Stringed