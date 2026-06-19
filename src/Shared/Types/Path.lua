local Path = {}

function Path.new(FilePath, Identifier)
    ---@class Path
    local PathObject = {}

    local SplitType = string.split(FilePath, "%.")
    local SplitPath = string.split(FilePath, "/")
    
    PathObject.Type = "Path"

    PathObject.FileType = (#SplitType > 1) and SplitType[#SplitType] or nil
    PathObject.FileName = SplitPath[#SplitPath]
    PathObject.FilePath = FilePath

    PathObject.Identifier = Identifier

    return PathObject
end

return Path