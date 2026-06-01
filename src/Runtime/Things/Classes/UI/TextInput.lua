local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class TextInput: Text
local TextInput = Things.Extend("Text")
local InputService = Runtime.Services.Service("InputService") ---@class InputService

function TextInput:new()
    TextInput.super.new(self)

    self.BackspaceDown = nil
    self.BackspaceDebounce = 0

    self.Hovering = false

    self.InputActive = false

    self.Placeholder = "Text" -- TODO
    self.Text = ""

    self.FocusEnd = Signal:New("TextInputFocus_End")
    self.FocusStart = Signal:New("TextInputFocus_Start")
    self.Typed = Signal:New("TextInput_Typed")
    
    self.BackspaceEvent = InputService.KeyEvent:Connect(function(IsDown)
        if IsDown then
            if self.InputActive then
                self:SetText(string.sub(self.Text, 0, -2))
                self.BackspaceDown = GlobalTick
            end
        else
            self.BackspaceDown = nil
        end
    end, Enum.InputCode.Backspace)

    self.InputEvent = LoveEvents.TextInput:Connect(function(Key)
        if (not self.InputActive or not self:IsVisible()) then return end

        self:SetText(self.Text..Key)
        self.Typed.Invoke(self.Text)
    end)

    Runtime.InterfaceManager.OnClick:Connect(function()
        if self.Hovering ~= self.InputActive then 
            self["Focus" .. (self.Hovering and "Start" or "End") ].Invoke()
        end
        self.InputActive = self.Hovering
        love.keyboard.setTextInput(self.InputActive)
        print(self.InputActive)
    end)
end

function TextInput:DefineAPI()
    TextInput.super.DefineAPI(self)

    self.Proxy.Icon("TextInput")
    self.Proxy.MakeCreatable()
end


function TextInput:OnRemove()
    self.BackspaceEvent:Disconnect()
    TextInput.super.OnRemove(self)
end

function TextInput:HandleKeys()
    -- Pain, good god this will be hell to script full support for
    if self.BackspaceDown and (GlobalTick - self.BackspaceDown) > 0.5 then
        if (GlobalTick - self.BackspaceDebounce) > 0.05 then
            self.BackspaceDebounce = GlobalTick
            self:SetText(string.sub(self.Text, 0, -2))
        end
    end
end

function TextInput:Update(dt)
    TextInput.super.Update(self, dt)

    self:HandleKeys()

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end

    self.Hovering = Utils.IntersectPoint2D(self:GetRect(), DisplayUI.MousePosition)
    --[[print("-------")
    print(self.Hovering,self.UUID)
    print(self.InputActive)
    print(self.Text)]]
end

return TextInput