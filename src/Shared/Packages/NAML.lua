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

    // XML-Like closing tags
    {/Objects}
]]

local NAML = {}

function NAML.Serialize(Data)
    
end

function NAML.Deserialize(Data)
    local Deserialized = {}

    local CurrentCategory

    for _, Line in pairs(string.split(Data, "\n")) do
		Line = string.gsub(Line, "\r", "")

        local _, _, Capture = string.find(Line, "{(%a+)}")
		
        if Capture then
            
        end
    end

    return Deserialized
end

return NAML