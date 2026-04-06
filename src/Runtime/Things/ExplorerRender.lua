local Things = Runtime.Things

local function RenderIcon(IconName,VectorPos,TreeStarter)
    local ImageThing = Things.New("Image2D")
    ImageThing.Position = Pivot2D.FromOffset(VectorPos)
    ImageThing.ImageFile = "Assets/EditorIcons/16/"..IconName..".png"
    ImageThing:SetParent(TreeStarter)
end

local function RenderTextLabel(Text,VectorPos,TreeStarter)
    local TextThing = Things.New("Text")
    TextThing.Position = Pivot2D.FromOffset(VectorPos)
    TextThing.Text = Text
    TextThing.Size = Pivot2D.FromOffset(Vector2.new(100,20))
    TextThing.TextColor = Color.new(1)
    TextThing.BGTransparency = 1
    TextThing:SetParent(TreeStarter)
end

return function ()
    local TreeStarter = Things.Root.Viewport
    local LastPosition = Vector2.new(0,0)

    local Children = table.clone(TreeStarter.Children)

    if TreeStarter.Explorer.Icon then
        RenderIcon(TreeStarter.Explorer.Icon,Vector2.one * 10,TreeStarter)
    else
        RenderIcon("cancel",Vector2.one * 10,TreeStarter)
    end

    for UIDD,v in pairs(Children) do -- Make something separeted for icons honestly
        local Thingy = Things.Get(UIDD)
        if Thingy.Explorer.Visible then
            local PosThisWay = Vector2.new(30,30+LastPosition.Y)

            if Thingy.Explorer.Icon then
                RenderIcon(Thingy.Explorer.Icon,PosThisWay,TreeStarter)
            else
                RenderIcon("cancel",PosThisWay,TreeStarter)
            end

            RenderTextLabel(Thingy.Name,PosThisWay+Vector2.xAxis*20,TreeStarter)
            LastPosition = PosThisWay
        end
    end
end