local Utils = {}

function Utils.OptionalCall(Module, Function, ...)
    if Module and Module[Function] then
        return Module[Function](...)
    end
end

function Utils.GetAlignment(Alignment, Container, Content)
    return (Container - Content) * Alignment
end

function Utils.IntersectPoint2D(Rect, Point)
    local XIntersect = (Point.X > Rect.Min.X) and (Point.X < Rect.Max.X)
    local YIntersect = (Point.Y > Rect.Min.Y) and (Point.Y < Rect.Max.Y)

    return (XIntersect and YIntersect)
end

function Utils.TypeOf(Object)
    if type(Object) == "table" then
        return Object.Type or "Table"
    else
        return type(Object)
    end
end

function Utils.AssertType(Object, ExpectedType, Extra)
    assert(Object.Type == ExpectedType, "Expected "..ExpectedType..", got "..Object.Type.." ("..Extra..")")
end

function Utils.DoesFileExist(Directory)
    return love.filesystem.getInfo(Directory) and true or false
end

function Utils.GetEnumNameByValue(EnumName,Val) -- i dont got any other ideas on how to do this
    local EnumGot = Enum[EnumName]
    for i,v in pairs(EnumGot) do
        if v == Val then
            return i
        end
    end
    return nil
end

function Utils.LoadModules(Path, Require)
    local Classes = {}
    local ClassesList = Utils.GetFolderDescendants(Path, false, true)

    for _, v in pairs(ClassesList) do
        local Path = string.split(v, "%/")
        local Name = Path[#Path]

        Classes[Name] = Require and require(v) or v
    end

    return Classes
end

-- Returns a table of all the files in a folder, regardless of if a file was nested or not
function Utils.GetFolderDescendants(Folder, NoPath, NoExtension)
    local FolderData = {}

    for _, FileName in pairs(love.filesystem.getDirectoryItems(Folder)) do
        local Info = love.filesystem.getInfo(Folder..FileName)

        if Info.type == "directory" then
            table.combine(FolderData, Utils.GetFolderDescendants(Folder..FileName.."/"))
        else
            table.insert(FolderData, Folder..FileName)
        end
    end

    -- Pain
    if NoPath then
        for i, Folder in pairs(FolderData) do
            local Path = string.split(Folder, "%/")

            FolderData[i] = Path[#Path]
        end
    end

    -- Pain 2
    if NoExtension then
        for i, Folder in pairs(FolderData) do
            FolderData[i] = string.split(Folder, "%.")[1]
        end
    end

    return FolderData
end

return Utils