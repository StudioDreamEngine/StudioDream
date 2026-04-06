-- Base class for thing
local Things = Runtime.Things
local Thing = Object:extend()

function Thing:new()
    self.Children = {}
    self.Parent = nil 
    self.UUID = CreateUUID()

    self.Explorer = {
        Visible = true,
        Icon = "shape_square"
    }

    self.Changed = Signal:New("PropertyChange")

    self.Changed:Connect(function(OldParent, NewParent)
        --print("New Parent:", NewParent.UUID)
    end, "Parent")
end

function Thing:GetParentCallback(Callback)
	local Parent = self
	
	repeat
        Parent = Parent.Parent

		-- We need to also be able to use the callback on the object iself
		if Parent and Callback(Parent) then
			break
		end
	until (not Parent)
	
	return Parent
end

function Thing:SetParent(NewParent)
    self.Parent = NewParent

    NewParent.Children[self.UUID] = true
end

function Thing:__newindex(index, value)
    if self.Changed then
        if type(value) == "table" then
            self.Changed.Invoke(index, self[index], value)
        end
    end

    return rawset(self, index, value)
end

function Thing:DescendantOf()
    local ReturnedDescendant = {}

    -- We should improve this, maybe getchildren with a callback>?
    local function GetChildOf(ThingTo)
        for ChildUUID, _ in pairs(ThingTo.Children) do
            local Child = Things.Get(ChildUUID) -- dont forget this is a thing!!#@!@
            table.insert(ReturnedDescendant, Child)
            if ThingTo.Children then
                GetChildOf(ThingTo)
            end
        end
    end
    
    GetChildOf(self)

    return ReturnedDescendant
end

function Thing:IsA(ObjectType)
    return self:is(Things.Type(ObjectType))
end

function Thing:GetChildren()
    local ReturnedChildren = {}

    for ChildUUID, _ in pairs(self.Children) do
        table.insert(ReturnedChildren, Things.Get(ChildUUID))
    end

    return ReturnedChildren
end

function Thing:GetDescendants()
    local ReturnedDescendants = {}

    local function GetDescendantsImpl(Object)
        for _, Descendant in pairs(Object:GetChildren()) do
            table.insert(ReturnedDescendants, Descendant)
            GetDescendantsImpl(Descendant)
        end
    end

    GetDescendantsImpl(self)

    return ReturnedDescendants
end

-- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
-- Idk what is this supost to do so im leaving it like this!!
function Thing:AncestorOf(Descendant)
    
end

function Thing:FindFirstChild(Name)
    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)

        if Child.Name == Name then
            return Child
        end
    end
end

function Thing:ClearAllChildren(NameFilter)
    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)
        if not NameFilter[Child.Name] then
            Things.Remove(Child)
        end
    end 
end

local function RenderIcon(IconName,VectorPos,TreeStarter)
    --[[local ImageC = love.graphics.newImage("Editor/Assets/Icons/16/"..IconName..".png")
    love.graphics.draw(ImageC,VectorPos.X,VectorPos.Y)]]

    local ImageThing = Things.New("Image2D")
    ImageThing.Position = Pivot2D.FromOffset(VectorPos)
    ImageThing.ExplorerVisible = false
    ImageThing.Icon = "bug"
    ImageThing.ImageFile = "Editor/Assets/Icons/16/"..IconName..".png"
    ImageThing.Name = "ICON_RENDER"
    ImageThing:SetParent(TreeStarter)
end

local function RenderTextLabel(Text,VectorPos)
    local font = love.graphics.getFont()
    local plainText = love.graphics.newText(font, {{1, 1, 1}, Text})
    love.graphics.draw(plainText,VectorPos.X,VectorPos.Y)
end

function Thing:RenderThingies(AlreadyLastPos,Renderer) -- TreeStarter Must be a thing not an UUID
    local TreeStarter = Renderer or self
    local LastPosition = AlreadyLastPos or Vector2.new(0,0)
    local index = 0

    print("started")

    if TreeStarter.Icon then
        RenderIcon(TreeStarter.Icon,Vector2.new(10,10),TreeStarter)
    else
        RenderIcon("cancel",Vector2.new(10,10),TreeStarter)
    end

    for UIDD,v in pairs(TreeStarter.Children) do -- Make something separeted for icons honestly
        local Thingy = Things.Get(UIDD)
        if Thingy.ExplorerVisible then
            index=index+1
            local PosThisWay = Vector2.new(20,index == 1 and LastPosition.Y+26 or LastPosition.Y+16)
            if Thingy.Icon then
                RenderIcon(Thingy.Icon,PosThisWay,TreeStarter)
            else
                RenderIcon("cancel",PosThisWay,TreeStarter)
            end
            --RenderTextLabel(tostring(UIDD),PosThisWay+Vector2.new(16,0))
            LastPosition = PosThisWay
            print(Thingy.Name)
            if #Thingy.Children~=0 then
                print(Thingy.Name .." Has Children!!!")
                Thingy:RenderThingies(LastPosition)
            end
        end
    end
end

function Thing:Update()
end

return Thing