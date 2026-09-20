---@diagnostic disable: cast-local-type, need-check-nil
local Root = Runtime.Things.Root

local RootScene = {}
local Loaded = {}

function RootScene.Unload()
    if Loaded.Identifier then
        Runtime.Resources.UnloadResource(Loaded.Identifier)
    end
end

function RootScene.LoadDefault()
    Root:Clear()
    Runtime.Project.Scenes.LoadDefault()

    RootScene.ConfigureTargets()
end

function RootScene.Load()
    local Project = Runtime.Project
    Root:Clear()

    -- Get the identifier id for the root scene
    local IdentifierID = Project.Config.Get("RootScene")

    local Resource = {
        References = {},
        Scene = nil
    }

    -- if there is one, load the resource thats there
    if IdentifierID then
        local Identifier = Runtime.Resources.GetIdentifierFromID(IdentifierID)
        Resource = Runtime.Resources.GetResource(Identifier, true)
    end

    if Resource.Scene then
        Loaded = {
            Identifier = IdentifierID
        }
    else
        Project.Scenes.LoadDefault() -- Load default project if we cannot find root scene
    end

    RootScene.ConfigureTargets()
end

-- Configure Hud and Environment viewports for new root scenes
function RootScene.ConfigureTargets()
    Loaded.Object = Runtime.Things.Root

    if Root.EnvironmentViewport and Root.HudViewport then
        Root.EnvironmentViewport:SetRenderContainer(Root:GetEnvironment())
        Root.HudViewport:SetRenderContainer(Root:GetHUD())
    end
end

function RootScene.Save()
    local Project = Runtime.Project

    -- Create the identifier if we dont have one yet
    if (not Loaded.Identifier) then
        Loaded.Identifier = Runtime.Resources.GetOrCreateIdentifierID("RootScene.sds")
    end

    Project.Scenes.SaveScene(Loaded.Identifier, Loaded.Object)
    Project.Config.Set("RootScene", Loaded.Identifier)
end

return RootScene