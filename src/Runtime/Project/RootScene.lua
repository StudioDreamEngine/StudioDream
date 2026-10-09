---@diagnostic disable: cast-local-type, need-check-nil
local Root = Runtime.Things.Root

local RootScene = {}
local CurrentEnv

local LoadedScenes = {}

function RootScene.Unload()
    print("Unload (TODO)")
end

function RootScene.LoadDefault()
    Root:Clear()
    Runtime.Things.CreateTemplate("Root")

    RootScene.ConfigureTargets()
end

-- Load an enviornment from an IdentifierID
function RootScene.LoadEnviornment(IdentifierID)
    if (IdentifierID == Root.Scene) then
        print("Cannot load root scene as environment")
        return
    end

    if CurrentEnv then
        CurrentEnv:RemoveParent(Root)
        CurrentEnv = nil

        Root:Collect()
    end

    local Identifier = Runtime.Resources.GetIdentifierFromID(IdentifierID)
    local Resource, _ = Runtime.Resources.GetResource(Identifier)
    Resource.Scene:SetParent(Root)

    CurrentEnv = Resource.Scene
    LoadedScenes[IdentifierID] = Resource.Scene

    RootScene.ConfigureTargets()

    return Identifier
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

    LoadedScenes = {}

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

    RootScene.SaveEnviornment()

    for _, Scene in pairs(LoadedScenes) do
        Project.Scenes.SaveScene(Scene)
    end

    Project.Scenes.SaveScene(Root)
    Project.Config.Set("RootScene", Root.Scene)
end

return RootScene