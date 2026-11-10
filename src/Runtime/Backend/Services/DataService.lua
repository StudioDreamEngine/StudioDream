local DataService = {}

DataService.SaveOn = nil
DataService.CurrentSavePath = nil

DataService.UpdatedCurrentSavePath = Signal:New("UpdatedCurrentSavePath")

function DataService:GetData(Name)
    local Path = DataService.CurrentSavePath.."/"..Name..".dat/"
    local File = love.filesystem.getInfo(Path)
    if File then
        return DataService:CreateData("",Path)
    end
end

function DataService:DoesProjectDataExist(CustomPath)
    return Utils.FileExists(CustomPath or DataService.CurrentSavePath)
end

function DataService:EditSavePath(NewSavePath)
    assert(not DataService:DoesProjectDataExist(NewSavePath),"An project is already using this data name!")

    local AbsolutePath = love.filesystem.getRealDirectory(DataService.CurrentSavePath).."/"..DataService.CurrentSavePath
    local NewPath = love.filesystem.getRealDirectory(DataService.CurrentSavePath).."/"..NewSavePath

    os.rename(AbsolutePath,NewPath)

    Runtime.Project.Config.Set("SaveIdentifier",NewSavePath)
    DataService.CurrentSavePath = NewSavePath
    DataService.UpdatedCurrentSavePath:Invoke()

    return true
end

function DataService:CreateData(Name,File)
    local WaitAMinute = DataService:GetData(Name)
    if WaitAMinute then 
        return WaitAMinute
    end

    local DataObject = setmetatable({},{
        __tostring = function(self)
            return "["..self.Name.." , "..self.Path.."]: "..tostring(self:GetSize()).."b"
        end,
    }) 

    DataObject.Path = File or DataService.CurrentSavePath.."/"..Name..".dat/"
    DataObject.AbsolutePath = love.filesystem.getRealDirectory(DataService.CurrentSavePath).."/"..DataObject.Path
    DataObject.Type = "Data"
    DataObject.File = love.filesystem.read(DataObject.Path)

    DataObject.UpdatedConnection = DataService.UpdatedCurrentSavePath:Connect(function()
        DataObject.Path = DataService.CurrentSavePath.."/"..DataObject.Name..".dat/"
        DataObject.AbsolutePath = love.filesystem.getRealDirectory(DataService.CurrentSavePath).."/"..DataObject.Path
    end)

    function DataObject:GetName()
        local Splitted = string.split(DataObject.Path,"/")
        local Name = string.gsub(Splitted[#Splitted-1],".dat","")
        return Name
    end

    DataObject.Name = DataObject:GetName()

    function DataObject:WriteData(SerializedString)
        assert(type(SerializedString)=="string","The serialized data needs to be a string!")
        love.filesystem.write(DataObject.Path,SerializedString)
    end

    function DataObject:GetData()
        local Data = love.filesystem.read(DataObject.Path)
        return Data
    end

    function DataObject:GetSize()
        local _,Data = love.filesystem.read(DataObject.Path)
        return Data
    end

    return DataObject
end

function DataService.CreateProjectDirectory()
    local ProjectDataPath = DataService.SaveOn
    DataService.CurrentSavePath = ProjectDataPath
    local Sucess = love.filesystem.createDirectory(ProjectDataPath)
end

function DataService.LoadProjectData(Project)
    DataService.SaveOn = Runtime.Project.Config.Get("SaveIdentifier")
    DataService.CreateProjectDirectory()
end

function DataService.Init()
   
end

return DataService


-- Maybe do like this?

-- Project Folder when compiled on where studiodream data is saved folder (not the actual folder of studiodream)
---- Project Name (folder)
------ Datas (folder)
------- NameOfTheFile (txt or lua or table idk)