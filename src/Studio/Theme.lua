local Themes = {}
local ThemesIn = {

    ThemeTest = {
        Outline = Color.FromHex("505050"),
        SecondaryOutline = Color.FromHex("#505050"),

        Secondary = Color.FromHex("#808080"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#A0a0a0"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#000000"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#FFFFFF"),

        Text = Color.FromHex("#ffffff"),
        Text2 = Color.FromHex("#ffffff"),
        TextInverse = Color.FromHex("#000000"),
        Error =  Color.FromHex("#ff3333"),

        FontNormal = "Roboto-Medium",
        FontBold = "Roboto-Bold"
    },

    BlueNight = {
        Outline = Color.FromHex("#0d1029"),
        SecondaryOutline = Color.FromHex("#9090b0"),

        Secondary = Color.FromHex("#151953"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#13152e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#2c2a77"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#2821ff"),

        Text = Color.FromHex("#ffffff"),
        Text2 = Color.FromHex("#ffffff"),
        TextInverse = Color.FromHex("#000000"),
        Error =  Color.FromHex("#ff3333"),
        FontNormal = "Roboto-Medium",
        FontBold = "Roboto-Bold"
    },

    Ocean = {
        Outline = Color.FromHex("#000427"),
        SecondaryOutline = Color.FromHex("#8d8dff"),

        Secondary = Color.FromHex("#00043b"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#000920"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#001a63"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#21c0ff"),

        Text = Color.FromHex("#ffffff"),
        Text2 = Color.FromHex("#ffffff"),

        FontNormal = "Roboto-Medium",
        FontBold = "Roboto-Bold"
    },

    DaySkyie = {
        Outline = Color.FromHex("#585858"),
        SecondaryOutline = Color.FromHex("#8d8dff"),

        Secondary = Color.FromHex("#a6a5b4"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#9a9ba3"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#e7e7e7"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#6998ff"),

        Text = Color.FromHex("#1a1a1a"),
        Text2 = Color.FromHex("#ffffff"),

        FontNormal = "Roboto-Medium",
        FontBold = "Roboto-Bold"
    },

    CodeMode = {
        Outline = Color.FromHex("#000000"),
        SecondaryOutline = Color.FromHex("#0e0e0e"),

        Secondary = Color.FromHex("#1d1d1d"), -- This color is meant to either be for less important stuff or to constrast the primary
        --Tertiary = Color.FromHex("#0e0e0e"), -- Brighter version of the secondary, meant to distinguish something thats over primary and secondary
        Primary = Color.FromHex("#252525"), -- This color is for the main parts, containers and such
    
        Selecting = Color.FromHex("#4a2bff"),

        Text = Color.FromHex("#3eff24"),
        Text2 = Color.FromHex("#3eff24"),

        FontNormal = "Assets/Fonts/SpaceGrotesk/SpaceGrotesk-Medium.ttf",
        FontBold = "Assets/Fonts/SpaceGrotesk/SpaceGrotesk-SemiBold.ttf"
    },
    --[[local DarkSky = {
    NodeColor = Color.new(0.314, 0.294, 0.502),
    WindowColor = Color.new(0.106, 0.09, 0.188),
    BackWindowColor = Color.new(0.149, 0.129, 0.333),
    OutlineColor = Color.new(0.004, 0, 0.161),
    }]]
}

Themes.CurrentTheme = ThemesIn.BlueNight

return Themes