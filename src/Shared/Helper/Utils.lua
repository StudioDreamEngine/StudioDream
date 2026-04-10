local Utils = {}

function Utils.OptionalCall(Module, Function, ...)
    if Module and Module[Function] then
        return Module[Function](...)
    end
end

function Utils.IntersectPoint2D(Rect, Point)
    local XIntersect = (Point.X < Rect.Min.X) and (Point.X > Rect.Max.X)
    local YIntersect = (Point.Y < Rect.Min.Y) and (Point.Y > Rect.Max.Y)

    return (XIntersect and YIntersect)
end

function Utils.AssertType(Object, ExpectedType, Extra)
    assert(Object.Type == ExpectedType, "Expected "..ExpectedType..", got "..Object.Type.." ("..Extra..")")
end

-- Returns a table of all the files in a folder, regardless of if a file was nested or not
function Utils.GetFolderDescendants(Folder, NoPath)
    local FolderData = {}

    for _, FileName in pairs(love.filesystem.getDirectoryItems(Folder)) do
        local Info = love.filesystem.getInfo(Folder..FileName)

        if Info.type == "directory" then
            table.combine(FolderData, Utils.GetFolderDescendants(Folder..FileName.."/"))
        else
            table.insert(FolderData, Folder..FileName)
        end
    end

    if NoPath then
        for i, Folder in pairs(FolderData) do
            local Path = string.split(Folder, "%/")

            FolderData[i] = Path[#Path]
        end
    end

    return FolderData
    -- TODO: Returns a table of all the files in a folder, so they can be organized 
end

return Utils