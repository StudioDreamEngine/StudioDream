local Enums = {
    Alignment = {
        TopLeft = Vector2.zero,
        TopRight = Vector2.new(1,0),
        TopCenter = Vector2.new(.5,0),
        MiddleLeft = Vector2.new(0,0.5),
        MiddleRight = Vector2.new(1,0.5),
        Center = Vector2.new(0.5,0.5),
        BottomLeft = Vector2.new(0,1),
        BottomRight = Vector2.new(1,1),
        BottomCenter = Vector2.new(0.5,1),
    },
    Shape = {
        Cube = 'cube',
        Ball = 'ball',
        Wedge = 'wedge',
        Arrow = 'arrow',
        Brick = 'brick'
    },
    FilterType = {
        Linear = "linear",
        Pixelated = "nearest"
    },
    OpenDialog = {
        Folder = "OpenFolderDialog",
        File = "OpenFileDialog",
    },
    LayoutDirection = {
        Horizontal = "Horizontal",
        Vertical = "Vertical"
    },
    StudioDialog = {
        Option = "Option"
    },
    Platform = {
        Android = "Android",
        iOS = "iOS",
        Linux = "Linux",
        Windows = "Windows",
    },
    Hierachy = {
        Added = "added",
        Removed = "removed"
    },
    AutomaticSize = {
        Y = Vector2.yAxis,
        X = Vector2.xAxis
    },
    Side = {
        Front = Vector3.zAxis,
        Back = -Vector3.zAxis,
        Left = Vector3.xAxis,
        Right = -Vector3.xAxis,
        Up = Vector3.yAxis,
        Down = -Vector3.yAxis,
    },
    MouseButton = {
        LeftClick = 1,
        MiddleClick = 3,
        RightClick = 2
    },
    MouseMode = {
        Free = 1,
        Locked = 2
    },
    SquareAxis = {
        X = "X",
        Y = "Y"
    },
    AudioType = {
        Static = "static",
        Stream = "stream",
    },
    EasingStyle = {
        Linear = "linear",
        QuadIn = "inQuad",
        QuartIn = "inQuart",
        QuintIn = "inQuint",
        CubicIn = "inCubic",
        SineIn = "inSine",
        ExpoIn = "inExpo",
        CircIn = "inCirc",
        ElasticIn = "inElastic",
        BackIn = "inBack",
        BounceIn = "inBounce",
        QuadOut = "outQuad",
        QuartOut = "outQuart",
        QuintOut = "outQuint",
        CubicOut = "outCubic",
        SineOut = "outSine",
        ExpoOut = "outExpo",
        CircOut = "outCirc",
        ElasticOut = "outElastic",
        BackOut = "outBack",
        BounceOut = "outBounce",
    },
    EasingMode = {
        In = "in",
        Out = "out",
        InOut = "inOut",
        OutIn = "outIn"
    },
    ScaleType = {
        Stretch = "stretch",
        LockAspect = "lockaspect",
        Crop = "crop",
    },
    CullMode = {
        Back = "back",
        Front = "front",
        None = "none"
    },
    InputCode = {
        -- Keyboard
        RightArrow = 'right',
        LeftArrow = 'left',
        UpArrow = 'up',
        DownArrow = 'down',

        A = 'a',B = 'b',C = 'c',
        D = 'd',E = 'e',F = 'f',
        G = 'g',H = 'h',I = 'i',
        J = 'j',K = 'k',L = 'l',
        M = 'm',O = 'o',P = 'p',
        Q = 'q',R = 'r',S = 's',
        T = 't',U = 'u',V = 'v',
        W = 'w',X = 'x',Y = 'y',
        Z = 'z',
        Cedilla = 'ç',

        One = '1',Two = '2',Three = '3',
        Four = '4',Five = '5',Six = '6',
        Seven = '7',Eight = '8',Nine = '9',
        Zero = '0',
        
        Tilde = '~', -- Tilded_Cedilhiarion_Of_escapism_alphabet_from_1990_09_07_Protestment

        Exclamation = "!",
        DQuote = '\"',
        Hashtag = '#',
        Dollar = "$",
        Ampersand = '&',
        Quote = "\'",

        LeftParenth = '(',
        RightParenth = ')',
        Asterisk = '*',
        Plus = '+',
        Comma = ',',
        Minus = '-',
        Punctuation = '.',
        ForwardSlash = '/',
        Colon = ':',
        Semicolon = ';',
        LessThan = '<',
        GreaterThan = '>', -- no BORRING!
        Equals = '=',
        QuestionMark = '?',
        Atsign = '@',
        LeftSquareBracket = '[',
        RightSquareBracket = ']',
        BlackSlash = "\\",
        Caret = '^',
        Underscore = '_',
        GraveAccent = '`',

        NumpadOne = 'kp1',NumpadTwo = 'kp2',NumpadThree = 'kp3',
        NumpadFour = 'kp4',NumpadFive = 'kp5',NumpadSix = 'kp6',
        NumpadSeven = 'kp7',NumpadEight = 'kp8',NumpadNine = 'kp9',
        NumpadZero = 'kp0',
        
        NumpadPunctuation = 'kp.',
        NumpadComma = 'kp,',
        NumpadFrontslash = 'kp/',
        NumpadAsterisk = 'kp*',
        NumpadMinus = 'kp-',
        NumpadPlus = 'kp+',
        NumpadEnter = 'kpenter',
        NumpadEquals = 'kp=',

        F1 = 'f1',F2 = 'f2',F3 = 'f3',
        F4 = 'f4',F5 = 'f5',F6 = 'f6',
        F7 = 'f7',F8 = 'f8',F9 = 'f9',
        F10 = 'f10', F11 = 'f11', F12 = 'f12',
        F13 = 'f13', F14 = 'f14',F15 = 'F15',
        F16 = 'f16',F17 = 'f17',F18 = 'f18',

        Space = 'space',
        Esc = 'escape',
        CapsLock = 'capslock',
        ScrollLock = 'scrolllock',

        LeftCtrl = 'lctrl',
        RightCtrl = 'rctrl',

        LeftShift = 'lshift',
        RightShift = 'rshift',

        LeftAlt = 'lalt',
        RightAlt = 'ralt',

        LeftGui = 'lgui',
        RightGui = 'rgui',

        PrintScreen = 'printscreen',
        Undo = 'undo',
        Power = 'power',
        Insert = 'insert',
        Enter = 'return', -- Should we name this Enter or something?
        Tab = 'tab',
        Clear = 'clear',
        Home = 'home',
        PageUp = 'pageup',
        PageDown = 'pagedown',
        Delete = 'delete',
        End = 'end',
        Mode = 'mode',
        Backspace = 'backspace',


        -- Controller
        GamepadA = 'gp_a',
        GamepadB = 'gp_b',
        GamepadX = 'gp_x',
        GamepadY = 'gp_y',
        DPadUp = 'gp_dpup',
        DPadDown = 'gp_dpdown',
        DPadRight = 'gp_dpright',
        DPadLeft = 'gp_dpleft',
        JoystickLeft = 'gp_leftstick',
        JoystickRight = 'gp_rightstick',
        LeftBump = 'gp_leftshoulder',
        RightBump = 'gp_rightshoulder',
        Misc = 'gp_misc1',
        GamepadBack = 'gp_back',
        GamepadGuide = 'gp_guide',
        GamepadStart = 'gp_start',

        
        -- Mouse
        MouseLeftClick = 'mlclick',
        MouseRightClick = 'mrclick',
        MouseScrolled = 'mscroll',


        --Mobile
        Touch = 'mtouch',
        

        -- Misc
        None = '□'
    }
}

for _, Enum in pairs(Enums) do
    Enum.NameFromValue = function(Value)
        return table.find(Enum, Value)
    end

    Enum.Type = "Enum"
    Enum.None = nil
end

return Enums