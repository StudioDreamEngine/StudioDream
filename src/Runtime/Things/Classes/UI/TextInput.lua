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

    self.BackspaceEvent = InputService.KeyEvent:Connect(function(IsDown)
        if IsDown then
            self:SetText(string.sub(self.Text, 0, -2))
            self.BackspaceDown = GlobalTick
        else
            self.BackspaceDown = nil
        end
    end, Enum.InputCode.Backspace)

    self.InputEvent = LoveEvents.TextInput:Connect(function(Key)
        if (not self.InputActive) then return end

        self:SetText(self.Text..Key)
    end)

    Runtime.InterfaceManager.OnClick:Connect(function()
        self.InputActive = self.Hovering
    end)
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
end

return TextInput