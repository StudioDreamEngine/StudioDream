local Splash = {}
local Things = Runtime.Things

local SplashStatus ---@class Text
local SplashShadow ---@class Text
local SplashLogo ---@class Image2D
local SplashLogoOutline ---@class Image2D
local SplashContainer ---@class Square

function Splash.ChangeStatus(NewStatus)
    Scheduler.Yield()
    SplashStatus:SetText(NewStatus)
    SplashShadow:SetText(NewStatus)
end

function Splash.Out()
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
        ForegroundTransparency = 1
    }, Enum.EasingStyle.ExpoOut, 2).Play()

    TweenService.CreateAndPlay(SplashContainer, {
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Linear, 1)

    SplashContainer:Destroy()
end

function Splash.Init()
    SplashContainer = Things.Create("Square") {
        Parent = Things.Root.RootViewport,
        Layer = 999,
        Name = "RuntimeSplash",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Color.FromHex("#222650")
    }

    SplashShadow = Things.Create("Text") {
        Parent = SplashContainer,
        Text = "Loading...",
        Size = Pivot2D.FromScale(1,.1),
        Alignment = Vector2.new(.5,0),
        ForegroundColor = Color.new(0,0,0),
        BackgroundTransparency = 1,
        ForegroundTransparency = 0.5,
        Position = Pivot2D.FromScale(0,.71)
    }

    SplashStatus = Things.Create("Text") {
        Parent = SplashContainer,
        Text = "Loading...",
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

    Scheduler.NewTask(Splash.Load)
end

function Splash.Load()
    Splash.ChangeStatus("Finishing Runtime setup")
    Shared.SetupBullet()
    Runtime.PostInit()

    Splash.ChangeStatus("Starting Target")
    Shared.StartTarget()
    Splash.ChangeStatus("")

    Splash.Out()
end

return Splash