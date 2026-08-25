local Path = {}

function Path.new(FilePath)
    ---@class Path
    local PathObject = {}

    local SplitType = string.split(FilePath, "%.")
    local SplitPath = string.split(FilePath, "/")
    
    PathObject.Type = "Path"

    PathObject.FileType = (#SplitType > 1) and SplitType[#SplitType] or nil
    PathObject.FileStem = SplitPath[#SplitPath]

    local Split2 = string.split(SplitType[1], "/")-- WHY
    PathObject.FileName = Split2[#Split2]
    
    PathObject.FilePath = FilePath
    PathObject.ParentPath = table.concat(SplitPath, "/", 1, #SplitPath-1).."/"

    function PathObject.GetParent()
        return Path.new(PathObject.ParentPath)
    end

    return PathObject
end

return Path