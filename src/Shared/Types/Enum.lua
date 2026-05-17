local Enums = {
    AlignmentX = {
        Left = 0,
        Center = 0.5,
        Right = 1
    },
    AlignmentY = {
        Top = 0,
        Center = 0.5,
        Bottom = 1
    },
    Shape = {
        Brick = 'brick',
        Ball = 'ball',
        Wedge = 'wedge',
        Arrow = 'arrow',
    },
    LayoutDirection = {
        Horizontal = "Horizontal",
        Vertical = "Vertical"
    },
    Device = {
        Android = "Android",
        iOS = "iOS",
        Linux = "Linux",
    },
    Hierachy = {
        Added = "added",
        Removed = "removed"
    },
    AutomaticSize = {
        Y = "Y",
        X = "X"
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
    EasingStyle = {
        Linear = "linear",
        Quad = "Quad",
        Quart = "Quart",
        Quint = "Quint",
        Cubic = "Cubic",
        Sine = "Sine",
        Expo = "Expo",
        Circ = "Circ",
        Elastic = "Elastic",
        Back = "Back",
        Bounce = "Bounce",
    },
    EasingMode = {
        In = "in",
        Out = "out",
        InOut = "inOut",
        OutIn = "outIn"
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