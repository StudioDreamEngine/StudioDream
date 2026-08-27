local function WinCopy(Source, Target)
    os.execute('copy "' .. Source .. '" "' .. Target .. '"')
end

-- Progress: Dialog object for progress itself
-- Build: Temporary build directory, linux only
-- ZipBytes: Love zip
return function(Progress, ZipBytes, BuildDirectory)
    Progress.SetStages(1)

    -- 1. Copy other files to build
    Progress.NextStage("Building for windows...")
    local dir = love.filesystem.getSourceBaseDirectory()
    WinCopy(dir, BuildDirectory)

    love.filesystem.remove("build/StudioDream.exe")

    local ExportPath = "build/LoveExport.exe"

    if not love.filesystem.getInfo(ExportPath) then
        Shared.QueueAbort("BUILD: could not find export template for windows")
        return false
    end

    local LoveBytes = love.filesystem.read(ExportPath)
    love.filesystem.write("build/Project.exe", LoveBytes .. ZipBytes)
    love.filesystem.remove(ExportPath)
end