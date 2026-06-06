local FilePathd = {}

local For = {
    ["MeshPath"] = "3D File",
}

local Is3DFile = {
    ".obj",
    ".fbx",
    ".glb"
}

function FilePathd.Start(FrameOption,Thing,Property)
    local MainText = Runtime.Things.Create("TextButton") {
        Text = Thing[Property],
        ForegroundColor = Studio.Theme.Text,
        BackgroundColor = Studio.Theme.Primary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        TextScaled = true,
        CornerRadius=5
    }

    MainText.Clicked:Connect(function()
        local NewPath = Platform.OpenFileDialog("Choose "..For[Property].." for "..Property)
        print(NewPath)
        --Thing[Property] = NewFile
        if type(NewPath) ~= "boolean" then
            local FileType = string.sub(NewPath,-4,-1)
            print(FileType)
            if Is3DFile[FilePath] then
                if Property == "MeshPath" then Thing:LoadObject(NewPath) end
                MainText.Text = Thing[Property]
            end
        end
        -- Find a way to check if the select file is a 3D file, maybe using string.sub? 💃💃
    end)
end

return FilePathd