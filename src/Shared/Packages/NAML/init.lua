--[[
    my idea is some kind of cross between TOML, XML and YAML
    NAML (Not a markup language)

    No comments for now
    Line-Dependent (as in parsed by line)

    These Define "Entity Categories", which are basically lists for entities
    {Objects}

    [Object UUID] // These define a new entity entry
    Name: (string)... // every entity property is defined by a key, followed by their universal seperator (: ), their type "(...)", then the value
    Resource: (kv)ID:blah;ResourceType:Test // the kv type is a flat list type that is less readable but easily parsable, intended for stuff where resolving doesnt matter
    Transform: (kv)1:0:0:0:0:1:0:0:0:0:1:0:0:0:0:1 // kv can also just be a list
    // I suppose as a last resort we can always just add json support too
]]

local NAML = {}
local Magic = "NAML1"

NAML.Util = require("Shared.Packages.NAML.Util")

NAML.SerializeList = NAML.Util.SerializeList
NAML.DeserializeList = NAML.Util.DeserializeList

-- god... there has to be a better way to do this
local function Escape(Str)
    return string.gsub(Str, "%s", "\\ "):gsub("%[", "\\["):gsub("%]", "\\]")
end

function NAML.Serialize()
    local Serializer = {} ---@class NAMLSerializer
    local Data = {}

    local CurrentCategory

    function Serializer.SetCategory(Category)
        CurrentCategory = Category
        
        if (not Data[CurrentCategory]) then
            Data[CurrentCategory] = {}
        end
    end

    -- Create a property to be used in the EntityData for an entity
    function Serializer.CreateData(Key, Type, Value)
        return {
            Key = Key,
            Type = Type,
            Value = Value
        } 
    end

    --[[
        Add an entity to the current NAML

        Type: Engine class for the entity
        ID: Unique identifier for the entity
        EntityData: List of Data Properties, created by CreateData
    ]]
    function Serializer.AddEntity(Type, ID, EntityData)
        table.insert(Data[CurrentCategory], {
            Type = Type,
            ID = ID,
            Data = EntityData
        })
    end

    --[[
        Create the final NAML string
    ]]
    function Serializer.GenerateNAML()
        local String = ""

        local function AddLine(Str)
            String = String..Str.."\n"
        end

        AddLine(Magic)

        for Category, Entities in pairs(Data) do
            AddLine("\n\n{"..Category.."}")

            for _, Entity in pairs(Entities) do
                AddLine("\n["..Escape(Entity.Type).." "..Entity.ID.."]")

                for _, Property in pairs(Entity.Data) do
                    AddLine(Property.Key..": ("..Property.Type..")"..(Property.Value or ""))
                end
            end
        end

        return String
    end

    return Serializer
end

function NAML.Deserialize(Data)
    local Deserializer = {} ---@class NAMLDeserializer
    local Entities = {
        None = {}
    }

    local CurrentCategory, CurrentEntity = "None", nil

    local function ParseLine(Line)
        local CategoryCapture = string.match(Line, "^{(%a+)}")
        if CategoryCapture then 
            CurrentCategory = CategoryCapture 
            Entities[CurrentCategory] = {}
            return
        end

        local EntityCapture = string.match(Line, "^%[([%w%s%-]+)%]")
        if EntityCapture then
            local Split = string.split(EntityCapture, " ")
            
            assert(#Split < 3, "Malformed entity definition "..EntityCapture)

            ---@class NAMLDeserializedEntity
            CurrentEntity = {
                ID = Split[2],
                Type = Split[1],
                Data = {}
            }

            table.insert(Entities[CurrentCategory], CurrentEntity)

            return
        end

        -- Capture string black magic
        local key, type, value = string.match(Line, "^([%a]+): %(([%w]+)%)(.*)")
        if key then
            assert(CurrentEntity, string.format("No entity defined during parsing of property token (%s %s %s)", key, type, value))

            CurrentEntity.Data[key] = {
                Type = type,
                Value = value
            }
        end
    end

    -- Not a bad way to do this, also not good
    for Index, Line in pairs(string.split(Data, "\n")) do
        Line = string.gsub(Line, "\r", "")

        if Index == 1 then
            assert((Line==Magic), "Invalid NAML file")
        end

        ParseLine(string.gsub(Line, "\r", ""))
    end

    function Deserializer.GetCategory(Category)
        return Entities[Category] or {}
    end

    return Deserializer
end

return NAML