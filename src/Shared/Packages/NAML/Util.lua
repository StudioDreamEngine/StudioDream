local Util = {}

local esequence = "[^\\]"

-- is there a better way
local function escape(Str)
    return tostring(Str):gsub(":", "\\:"):gsub(";", "\\;")
end

---@param List table
function Util.SerializeList(List)
    return JSON.encode(List)

    --[[local Final = ""

    for Index, Value in pairs(List) do
        Final = Final..escape(Index)..";"..escape(Value)..":"
    end

    return Final]]
end

---@param List string
function Util.DeserializeList(List)
    return JSON.decode(List)

    --[[local ByElement = string.split(List, esequence..":")
    local Final = {}
    
    for _, Element in pairs(ByElement) do
        local BySeq = string.split(Element, esequence..";")
        assert(#BySeq < 3, "Invalid, "..List)

        local Index = BySeq[1]
        local Value = BySeq[2]

        if Schema.IsNumber then Value = tonumber(Value) end
        if Schema.IsList then Index = tonumber(Index) end

        ---@diagnostic disable-next-line: need-check-nil
        Final[Index] = Value
    end

    return Final]]
end

return Util