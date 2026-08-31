local Splash = {}
local Things = Runtime.Things

local SplashStatus ---@class Text
local SplashShadow ---@class Text
local SplashLogo ---@class Image2D
local SplashLogoOutline ---@class Image2D
local SplashContainer ---@class Square

function Splash.ChangeStatus(NewStatus)
    if FLAGS.Independent then return end
    printVerbose(NewStatus)

    if FLAGS.Verbose or FLAGS.Independent then
        DebugLog(NewStatus)
    else
        Scheduler.Yield()
        SplashStatus:SetText(NewStatus)
        SplashShadow:SetText(NewStatus)
    end
end

function Splash.Cleanup()
    SplashStatus = nil
    SplashShadow = nil
    SplashLogo = nil
    SplashLogoOutline = nil
    SplashContainer = nil
end

function Splash.Out()
    SplashStatus:Destroy()
    SplashShadow:Destroy()
    Scheduler.Yield()

    local StartSound = love.audio.newSource("/Assets/DefaultSounds/Jingle.wav", "static")
    love.audio.play(StartSound) -- Temporary?

    local TweenService = Runtime.Services.Service("TweenService") ---@class TweenService

    TweenService.CreateAndPlay(SplashLogo, {
        Size = Pivot2D.FromScale(.45,.45)
    }, Enum.EasingStyle.ExpoOut, .2)

    TweenService.Create(SplashLogo, {
        Size = Pivot2D.FromScale(0.1,0.1),
        ForegroundTransparency = 1
    }, Enum.EasingStyle.ExpoOut, 1).Play()

    TweenService.Create(SplashLogoOutline, {
        Size = Pivot2D.FromScale(2,2),
        ForegroundTransparency = 1,
        Rotation = 360,
    }, Enum.EasingStyle.ExpoOut, 2).Play()

    TweenService.CreateAndPlay(SplashContainer, {
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Linear, 1)

    SplashContainer:Destroy()
    Splash.Cleanup()
end

function Splash.Create()
    if FLAGS.Independent then return end
    printVerbose("Create splash")

    SplashContainer = Things.Create("Square") {
        Parent = Things.RenderRoot,
        Layer = 999,
        Name = "RuntimeSplash",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Color.FromHex("#222650")
    }

    SplashShadow = Things.Create("Text") {
        Parent = SplashContainer,
        Text = "Setting Up...",
        Size = Pivot2D.FromScale(1,.1),
        Alignment = Vector2.new(.5,0),
        ForegroundColor = Color.new(0,0,0),
        BackgroundTransparency = 1,
        ForegroundTransparency = 0.5,
        Position = Pivot2D.FromScale(0,.71)
    }

    SplashStatus = Things.Create("Text") {
        Parent = SplashContainer,
        Text = "Setting Up...",
        Size = Pivot2D.FromScale(1,.1),
        Alignment = Vector2.new(.5,0),
        ForegroundColor = Color.new(1,1,1),
        Layer = 2,
        BackgroundTransparency = 1,
        Position = Pivot2D.FromScale(0,.7)
    }

    SplashLogo = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(.35,.35),
        Layer = 2,
        Pivot = Vector2.new(.5,.5),
        Resource = "Internal/Icons/"..FLAGS.Target..".png",
        Position = Pivot2D.FromScale(.5,.4),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = SplashContainer
    }

    SplashLogoOutline = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(.25,.25),
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.5,.4),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/SplashOutline.png",
        Parent = SplashContainer
    }
end

function Splash.Load()
    printVerbose("Start load")
    local SplashError = function(FullMsg) error(FullMsg.."\n\nSplash Stack (IGNORE)") end
    Scheduler.OnRecoverableError = SplashError

    Splash.ChangeStatus("Setup Physics Engine")
    Shared.SetupBullet()

    Splash.ChangeStatus("Finishing Runtime Setup")
    Runtime.PostInit()

    Splash.ChangeStatus("Starting Target")
    Shared.StartTarget()

    Splash.ChangeStatus("Loading Project")
    Runtime.PostTarget(FLAGS.TargetProject)

    printVerbose("Sucessfully Finished Initalization")
    if (Scheduler.OnRecoverableError == SplashError) then
        Scheduler.OnRecoverableError = nil
    end

    if (not FLAGS.SecondRun) then
        Splash.Out()
    else
        SplashContainer:Destroy()
    end

    if FLAGS.SecondRun and Shared.Target ~= "Client" then
        Runtime.Project.LoadedProject.Invoke()
    end
end

return Splash