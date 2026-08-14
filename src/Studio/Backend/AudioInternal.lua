local AudioInternal = {}

AudioInternal.Volumes = {
    SFX = 100,
}

function AudioInternal.PlayAudio(Path,Configs)
    local PlayAudio = Runtime.Things.Create("Audio") {
        Resource = Path,
        Volume = Configs.DoesntLinkWithMaster and 100 or AudioInternal.Volumes.SFX
    }
    PlayAudio:Play()
    --[[PlayAudio.StoppedPlaying:ConnectOnce(function()
        print("Destroy on stop play")
        PlayAudio:Destroy()
    end)]]
end

return AudioInternal