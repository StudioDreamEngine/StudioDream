local Themes = {}
local ThemesIn = {

    ["ThemeTest"] = {
        Outline = Color.FromHex("505050"),
        SecondaryOutline = Color.FromHex("#505050"),

        Secondary = Color.FromHex("#808080"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#A0a0a0"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#000000"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#FFFFFF"),
        Text = Color.FromHex("#ffffff"),
        Error =  Color.FromHex("#ff3333"),

        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["Blue Night"] = {
        Outline = Color.FromHex("#020222"),
        SecondaryOutline = Color.FromHex("#9090b0"),

        Secondary = Color.FromHex("#100e35"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#13152e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#1a174b"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#2821ff"),
        Text = Color.FromHex("#ffffff"),

        Error =  Color.FromHex("#ff3333"),
        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["Concept"] = {
        Outline = Color.FromHex("#322F4A"),
        SecondaryOutline = Color.FromHex("#9090b0"),

        Secondary = Color.FromHex("#3B3755"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#13152e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#505268"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#2821ff"),
        Text = Color.FromHex("#ffffff"),

        Error =  Color.FromHex("#ff3333"),
        FontNormal = "Internal/Fonts/Arial/Arial.ttf",
        FontBold = "Internal/Fonts/Arial/Arial-Bold.ttf",
        FontTalic = "Internal/Fonts/Arial/Arial-Bold.ttf",
    },

    ["Dead By Night"] = {
        Outline = Color.FromHex("#111121"),
        SecondaryOutline = Color.FromHex("#9090b0"),

        Secondary = Color.FromHex("#22214c"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#13152e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#3a387a"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#2821ff"),
        Text = Color.FromHex("#ffffff"),

        Error =  Color.FromHex("#ff3333"),
        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["Companied"] = {
        Outline = Color.FromHex("#121213"),
        SecondaryOutline = Color.FromHex("#9090b0"),

        Secondary = Color.FromHex("#1d1d20"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#13152e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#504f55"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#547cff"),
        Text = Color.FromHex("#ffffff"),

        Error =  Color.FromHex("#ff3333"),
        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["Ocean"] = {
        Outline = Color.FromHex("#000427"),
        SecondaryOutline = Color.FromHex("#8d8dff"),

        Secondary = Color.FromHex("#00043b"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#000920"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#001a63"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#21c0ff"),

        Text = Color.FromHex("#ffffff"),

        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["DaySkyie"] = {
        Outline = Color.FromHex("#585858"),
        SecondaryOutline = Color.FromHex("#8d8dff"),

        Secondary = Color.FromHex("#a6a5b4"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#9a9ba3"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#e7e7e7"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#6998ff"),

        Text = Color.FromHex("#1a1a1a"),

        FontNormal = "Internal/Fonts/Roboto/Roboto-Medium.ttf",
        FontBold = "Internal/Fonts/Roboto/Roboto-Bold.ttf",
        FontTalic = "Internal/Fonts/Roboto/Roboto-Italic.ttf",
    },

    ["Code-Mode"] = {
        Outline = Color.FromHex("#000000"),
        SecondaryOutline = Color.FromHex("#0e0e0e"),

        Secondary = Color.FromHex("#1d1d1d"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#0e0e0e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#252525"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#000000"),

        Text = Color.FromHex("#3eff24"),

        FontNormal = "Internal/Fonts/SpaceGrotesk/SpaceGrotesk-Regular.ttf",
        FontBold = "Internal/Fonts/SpaceGrotesk/SpaceGrotesk-SemiBold.ttf",
        FontTalic = "Internal/Fonts/SpaceGrotesk/SpaceGrotesk-Bold.ttf"
    },
    --[[local DarkSky = {
    NodeColor = Color.new(0.314, 0.294, 0.502),
    WindowColor = Color.new(0.106, 0.09, 0.188),
    BackWindowColor = Color.new(0.149, 0.129, 0.333),
    OutlineColor = Color.new(0.004, 0, 0.161),
    }]]
}

Themes.CurrentTheme = ThemesIn["Blue Night"]

Themes.ThemeChanged = Signal:New("ThemeChanges")

Themes.ThemeChanged:Connect(function()
    print("UPDATED!!!!!!!!!!!")
    Studio.EditorUI.RedrawEverything()
end)

function Themes.GetCurrentThemeInfo()
    for i,v in pairs(ThemesIn) do
        if v == Themes.CurrentTheme then
            return i,v
        end
    end
end

function Themes.GetThemes()
    return ThemesIn
end

return Themes