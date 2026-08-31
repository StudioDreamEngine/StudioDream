local Utils = {}

function Utils.GetAlignment(Alignment, Container, Content)
    return (Container - Content) * Alignment
end

function Utils.IntersectPoint2D(Rect, Point)
    local XIntersect = (Point.X > Rect.Min.X) and (Point.X < Rect.Max.X)
    local YIntersect = (Point.Y > Rect.Min.Y) and (Point.Y < Rect.Max.Y)

    return (XIntersect and YIntersect)
end

-- Wrap a function that runs in the main loop as "non-critical"
function Utils.NonCritical(Function)
    -- TODO
end

function Utils.TypeOf(Object)
    if type(Object) == "table" then
        return Object.Type or "table"
    else
        return type(Object)
    end
end

function Utils.SerializeMyTable(Table,CustomSerialize)
    CustomSerialize = CustomSerialize or {}
	local Proxied = setmetatable({}, {
		__index = Table,
		__pairs = function(...)
            local BuildedTable = {}
            for i,v in pairs(Table) do
                if i~="Type" then
                    if not table.find(CustomSerialize,i) then
                        BuildedTable[i] = v
                    end
                end
            end
			return pairs(BuildedTable)
		end,
        __ipairs = function(...)
            local BuildedTable = {}
            for i,v in pairs(Table) do
                if i~="Type" then
                    if not table.find(CustomSerialize,i) then
                        BuildedTable[i] = v
                    end
                end
            end
			return ipairs(BuildedTable)
		end,
        __clone = function()
            return table.rawclone(Table)
        end
	})
	return Proxied
end

function Utils.IsAllPropertiesTheSame(table,CheckProperty)
    local FirstVal = table[1] and table[1][CheckProperty]
    for _, Thing in pairs(table) do
        if Thing[CheckProperty] ~= FirstVal then
            return false
        end
    end
    return true
end

function Utils.Boolean(Value)
    local Final

    -- God... why..........
    if (type(Value) ~= "nil") then Final = (Value and true or false)
    else Final = nil end

    return Final
end

function Utils.AssertType(Object, ExpectedType)
    local Type = Utils.TypeOf(Object)

    assert(Type == ExpectedType, "Expected "..ExpectedType..", got "..Type)
end

function Utils.AssertTypes(Objects, ExpectedType)
    for _, Object in pairs(Objects) do
        Utils.AssertType(Object, ExpectedType)
    end
end

function Utils.Keys(Table)
    local KeysTable = {}
    for i,_ in pairs(Table) do table.insert(KeysTable, i) end

    return KeysTable
end

function Utils.FileExists(Directory)
    return love.filesystem.getInfo(Directory) and true or false
end

-- Shouldnt be a util but whatever ig
function Utils.Warn(Message)
    Utils.SendNotification(Message, "Warn")
end

function Utils.TextureToImageData(Text)
    local width = Text:getWidth()
    local height = Text:getHeight()
    return love.graphics.readbackTexture(Text, 1, 1, 0, 0, width, height)
end

function Utils.SendNotification(Message,Type)
    if Type ~= "Warn" then
        print("Usage of Utils.SendNotification outside of Utils.Warn is highly discouraged and will be deprecated in the future")
    end

    Studio.Layout.GetHandle("Notification").Notify(Message,Type)
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