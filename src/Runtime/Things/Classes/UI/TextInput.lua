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

    self.Text = ""
    self.Placeholder = "Placeholder" -- TODO
    self.PlaceholderActive = false

    self.ClearWhenFocus = false

    self.FocusEnd = Signal:New("TextInputFocus_End")
    self.FocusStart = Signal:New("TextInputFocus_Start")
    self.Typed = Signal:New("TextInput_Typed")

    self.KeyEvent = InputService.KeyEvent:Connect(function(IsDown, Key)
        if (IsDown) then
            if (not self.InputActive) then return end

            if (Key == Enum.InputCode.Enter) then
                self:StopFocus()
            elseif (Key == Enum.InputCode.Backspace) then
                self:SetText(string.sub(self.Text, 0, -2))
                self.BackspaceDown = GlobalTick
            elseif (Key == Enum.InputCode.LeftArrow) then
                self.RenderClass:ChangePosBy(-1)
            elseif (Key == Enum.InputCode.RightArrow) then
                self.RenderClass:ChangePosBy(1)
            end
        elseif (Key == Enum.InputCode.Backspace) then
            self.BackspaceDown = nil
        end
    end)

    self.FocusStart:Connect(function()
        if self.ClearWhenFocus then
            self:SetText("")
        end
    end)

    self.InputEvent = LoveEvents.TextInput:Connect(function(Key)
        if (not self.InputActive or not self:IsVisible()) then return end

        self:SetText(self.Text..Key)
    end)

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Active then return end
        
        if self.Hovering then
            self:StartFocus()
        else
            self:StopFocus()
        end
    end)
end

function TextInput:OnReady()
    self.RenderClass = Runtime.Renderer.Input() ---@class InputRender
    self.RenderClass:new()
end

function TextInput:StartFocus()
    if not self.Active then return end
    self.FocusStart.Invoke()
    self.InputActive = true

    self.RenderClass:ToggleFocus(self.InputActive)
end

function TextInput:StopFocus()
    if not self.Active then return end
    self.FocusEnd.Invoke()
    self.InputActive = false

    self.RenderClass:ToggleFocus(self.InputActive)
end

function TextInput:DefineAPI()
    TextInput.super.DefineAPI(self)

    self.Proxy.Icon("TextInput")
    self.Proxy.Property("boolean Active")
    self.Proxy.Group("Transform","Active")
    self.Proxy.MakeCreatable()
end

-- For now we can do it this way, but later on we really shouldnt
function TextInput:HandlePlaceholderVisuals(IsPlaceholder)
    if IsPlaceholder then
        self:SetAbsoluteText(self.Placeholder)
    else
        self:SetAbsoluteText(self.Text)
    end

    self.PlaceholderActive = IsPlaceholder
end

function TextInput:SetPlaceholder(NewPlaceholder)
    self.Placeholder = NewPlaceholder
    self:HandlePlaceholderVisuals((self.Text == ""))
end

function TextInput:SetText(Text)
    TextInput.super.SetText(self, Text)

    self:HandlePlaceholderVisuals((self.Text == ""))
    self.Typed.Invoke(self.Text)
end

function TextInput:Draw()
    self.TextColorMultiplier = self.PlaceholderActive and 0.5 or 1
    
    TextInput.super.Draw(self)
end

function TextInput:ProcessInvalidations()
    TextInput.super.ProcessInvalidations(self)

    self.RenderClass:ChangePos(#self.Text)
end

function TextInput:OnInitalParent(NewParent)
    TextInput.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function TextInput:OnRemove()
    self.KeyEvent:Disconnect()
    self.FocusEnd:DisconnectAll()
    self.FocusStart:DisconnectAll()
    self.Typed:DisconnectAll()

    Runtime.InterfaceManager.UnregisterButton(self.UUID)
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
end

return TextInput