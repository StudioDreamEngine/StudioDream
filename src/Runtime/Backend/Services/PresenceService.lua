---@class PresenceService
local PresenceService = {}
PresenceService._discordInitialized = false

function PresenceService.Init()
    PresenceService._nextPresenceUpdate = 0

    PresenceService.State = ""
    PresenceService.Details = ""
end

function PresenceService.InitDiscord(applicationId)
    if (PresenceService._discordInitialized) then return end

    -- mikls required essay from your loved one, sonickirb :3
    -- the application id is public information, so you dont need to keep it private unlike a Discord bot token
    -- by default we'll just use the StudioDream applicationId
    -- :3
    DiscordRPC.initialize(applicationId or "1530703930772820160", true)
    PresenceService._discordInitialized = true
end

function PresenceService.Update(dt)
    if (not PresenceService._discordInitialized) then return end

    if (PresenceService._nextPresenceUpdate < love.timer.getTime()) then
        DiscordRPC.updatePresence({ -- "It's that easy!" :3
            state = PresenceService.State,
            details = PresenceService.Details
        })
        PresenceService._nextPresenceUpdate = love.timer.getTime() + 2.0
    end
    DiscordRPC.runCallbacks()
end

-- to be supported, on destroy
function PresenceService.OnDestroy()
    DiscordRPC.shutdown()
end

return PresenceService