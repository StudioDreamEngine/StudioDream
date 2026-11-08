local ffi = require("ffi")

local WindowManager = {}
local SDLWindow = nil
local HitTest

WindowManager.Bar = {
    Height = 0,
    Enabled = false,
}
WindowManager.Padding = 2

ffi.cdef([[
    typedef struct SDL_Window SDL_Window;

    typedef struct SDL_Point {
        int x;
        int y;
    } SDL_Point;

    typedef int (*SDL_HitTest)(SDL_Window *win, const SDL_Point *area, void *data);

    SDL_Window ** SDL_GetWindows(int *count);
    bool SDL_SetWindowHitTest(SDL_Window *window, SDL_HitTest callback, void *callback_data);

    bool SDL_MaximizeWindow(SDL_Window *window);
    bool SDL_MinimizeWindow(SDL_Window *window);
    bool SDL_RestoreWindow(SDL_Window *window);

    const char * SDL_GetError(void);
]])

function WindowManager.ConfigureTitleBar(Enabled, Size)
    local ViewportManager = Runtime.Renderer.ViewportManager

    WindowManager.Bar.Enabled = Enabled
    WindowManager.Bar.Height = Size

    if Enabled then
        local Platform = Runtime.Services.Service("PlatformService") ---@class PlatformService
        
        Platform.SetFlag("borderless", Enabled)
    end

    loveC.SDL_SetWindowHitTest(SDLWindow, Enabled and HitTest or nil, nil)
    ViewportManager.UpdateSize()
end

function WindowManager.Init()
    local Result = loveC.SDL_GetWindows(ffi.new("int[1]", 1))
    SDLWindow = Result[0]

    -- the fuck do you mean i can just do this???
    HitTest = ffi.cast("SDL_HitTest", function(_, area, _)
        local Result = 0
        local WinSize = Runtime.Backend2D.GetWindowSize(true)

        if (area.y < WindowManager.Bar.Height) and (not Runtime.InterfaceManager.Hovering) then
            Result = 1
        end

        return ffi.cast("int", Result)
    end)
end

return WindowManager