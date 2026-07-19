local Path = {}

function Path.new(FilePath)
    ---@class Path
    local PathObject = {}
    FilePath = Platform.ParsePath(FilePath)

    local SplitType = string.split(FilePath, "%.")
    local SplitPath = string.split(FilePath, "/")
    
    PathObject.Type = "Path"

    PathObject.FileType = (#SplitType > 1) and SplitType[#SplitType] or nil
    PathObject.FileName = SplitPath[#SplitPath]
    PathObject.FilePath = FilePath
    PathObject.ParentPath = table.concat(SplitPath, "/", 1, #SplitPath-1).."/"

    return PathObject
end

return Path