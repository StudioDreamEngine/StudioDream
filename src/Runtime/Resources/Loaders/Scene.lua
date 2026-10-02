local Scenes = Runtime.Project.Scenes

return function(SceneBytes, Identifier)
    local Deserializer = NAML.Deserialize(SceneBytes)

    Scenes.Objects.SetSerializers(nil, Deserializer)
    
    local Scene, References = Scenes.Objects.DeserializeObjects(Deserializer.GetCategory("Root"), Deserializer.GetCategory("Objects"))
    Scene.Scene = Identifier.ID

    return {
        Scene = Scene,
        References = References,
        Resolve = function()
            Scenes.Objects.ResolveReferences(References)
        end
    }
end