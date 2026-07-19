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

local SecondsPerMinute = 60
local SecondsPerHour = SecondsPerMinute * 60
local SecondsPerDay = SecondsPerHour * 24

function Utils.TimeAgo(Time)
    local Difference = os.time()-Time

    if Difference > SecondsPerDay then
        return math.round(Difference/SecondsPerDay).." Days Ago"   
    elseif Difference > SecondsPerHour then
        return math.round(Difference/SecondsPerHour).." Hours Ago"   
    elseif Difference > SecondsPerMinute then
        return math.round(Difference/SecondsPerMinute).." Minutes Ago"  
    else
        return Difference.." Seconds ago"
    end
end

function Utils.AssertType(Object, ExpectedType, Extra)
    assert(Object.Type == ExpectedType, "Expected "..ExpectedType..", got "..Object.Type.." ("..Extra..")")
end

function Utils.Keys(Table)
    local KeysTable = {}
    for i,_ in pairs(Table) do table.insert(KeysTable, i) end

    return KeysTable
end

function Utils.FileExists(Directory)
    return love.filesystem.getInfo(Directory) and true or false
end

function Utils.DebrisThing(Obj,Timer)
    Scheduler.DelayTask(Timer,function()
        Obj:Destroy()
    end)
end

function Utils.CountTable(Table) error("Utils.CountTable is deprecated, use table.length(Table) instead.") end ---@deprecated
function Utils.UltraCloneTable(Table) error("Utils.UltraCloneTable is deprecated, use table.deepcopy(Table) instead.") end ---@deprecated
function Utils.GetEnumNameByValue(EnumName,Val) error("Utils.GetEnumNameByValue is deprecated, Enum-related utilities should be in the enum perhaps") end ---@deprecated

function Utils.Warn(Message)
    Utils.SendNotification(Message, "Warn")
end

function Utils.TextureToImageData(Text)
    local width = Text:getWidth()
    local height = Text:getHeight()
    return love.graphics.readbackTexture(Text, 1, 1, 0, 0, width, height)
end

function Utils.SendNotification(Message,Type)
    --if Type ~= "Warn" or Type ~= "Info" or Type ~= "Error" then return end

    Studio.Layout.GetHandle("Notification").Notify(Message,Type)
end

function Utils.SetMode(WidthAndHeight,Stuff)
    Stuff["depth"] = true
    -- TODO: When theres no stuff, make so it gets the saved Stuff, or just create a table
    love.window.setMode(WidthAndHeight.X, WidthAndHeight.Y,Stuff)
end

function Utils.SetWindowSize(Vect2)
    assert("SetWindowSize is deprecated, try using Utils.SetMode")
    --love.window.setMode(Vect2.X, Vect2.Y,{depth = true})
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