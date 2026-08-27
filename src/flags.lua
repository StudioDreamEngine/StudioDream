return {
    Target = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = false,
    DebugDraw = false,
    ExternalOutput = true,
    Independent = false,
    TargetProject = nil,
    ProfileCapture = false,
    SecondRun = false,
    AlwaysCollect = false,
    --CallSetPropertyOnDirect = true,
}