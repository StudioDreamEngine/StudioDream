local AudioInternal = {}

AudioInternal.Volumes = {
    SFX = 100,
}

function AudioInternal.PlayAudio(Path,Configs)
    local PlayAudio = Studio.Components.CreateStyle("Audio", {
        Resource = Path,
        Volume = Configs.DoesntLinkWithMaster and 100 or AudioInternal.Volumes.SFX
    })
    PlayAudio:Play()
    PlayAudio.StoppedPlaying:ConnectOnce(function()
        PlayAudio:Destroy()
    end)
end

return AudioInternal