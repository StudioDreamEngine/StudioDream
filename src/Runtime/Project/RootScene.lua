---@diagnostic disable: cast-local-type, need-check-nil
local Root = Runtime.Things.Root

local RootScene = {}
local CurrentEnv

function RootScene.Unload()
    print("Unload")
end

function RootScene.LoadDefault()
    Root:Clear()
    Runtime.Things.CreateTemplate("Root")

    RootScene.ConfigureTargets()
end

-- Load an enviornment from an IdentifierID
function RootScene.LoadEnviornment(IdentifierID)
    if CurrentEnv then
        CurrentEnv:Destroy()
        CurrentEnv = nil

        Root:Collect()
    end

    local Identifier = Runtime.Resources.GetIdentifierFromID(IdentifierID)
    local Scene, _ = Runtime.Resources.GetResource(Identifier, true)
    Scene.Scene:SetParent(Root)
    RootScene.ConfigureTargets()

    return Identifier
end

function RootScene.GetAllProjectScenes()
    local Classes = {}
    local ClassesList = Utils.GetFolderDescendants(Runtime.ProjectFS.GetMount(), false, false)
    print(Runtime.ProjectFS.GetMount())
    print(ClassesList)
    for _, v in pairs(ClassesList) do
        print(v)
        local Path = string.split(v, "%/")
        local Name = Path[#Path]

        v = string.gsub(v, "/", "%.")

        print(v)
    end

    return Classes
end
-- Save the current enviornment
function RootScene.SaveEnviornment()
    local Project = Runtime.Project

    if CurrentEnv then
        Project.Scenes.SaveScene(CurrentEnv)
    else
        printVerbose("No enviornment scene is currently open")
    end
end

function RootScene.Load()
    local Project = Runtime.Project
    Root:Clear()

    -- Get the identifier id for the root scene
    local IdentifierID = Project.Config.Get("RootScene")

    -- if there is one, load the resource thats there
    if IdentifierID then
        local Identifier = Runtime.Resources.GetIdentifierFromID(IdentifierID)
        Runtime.Resources.GetResource(Identifier, true)
    else
        printVerbose("No root scene found, is this a new project?")

        IdentifierID = Runtime.Resources.GetOrCreateIdentifierID("RootScene.sds")
        Root.Scene = IdentifierID

        RootScene.LoadDefault()
    end

    RootScene.ConfigureTargets()
end
-- Configure Hud and Environment viewports for new root scenes
function RootScene.ConfigureTargets()
    if Root.EnvironmentViewport and Root.HudViewport then
        Root.EnvironmentViewport:SetRenderContainer(Root:GetEnvironment())
        Root.HudViewport:SetRenderContainer(Root:GetHUD())
    end
end

function RootScene.Save()
    local Project = Runtime.Project

    Project.Scenes.SaveScene(Root)
    Project.Config.Set("RootScene", Root.Scene)
end

return RootScene