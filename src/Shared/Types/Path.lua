local Path = {}

function Path.new(FilePath, Identifier)
    ---@class Path
    local PathObject = {}

    local SplitPath = string.split(FilePath, "%.")
    
    PathObject.Type = "Path"
    PathObject.FileType = SplitPath[2]
    PathObject.FilePath = FilePath
    PathObject.Identifier = Identifier

    return PathObject
end

return Path