local Preprocessor = {}
--[[
    Enable usage of self-assignment operators
]]

local Keywords = {"local", "function", "if", "for", "return", "while"}

---@param ScriptContents string
function Preprocessor.ProcessScript(ScriptContents)
    local Replacements = {}

    -- Find self-assigment operators
    for i,v in string.gfind(ScriptContents,  "[%+%-%/%*]=") do
        local Operator = string.sub(v,1,1)
        
        --[[
            Look for where our variable starts and the name of the variable itself

            There is probably a better way to do this, but this is the best way i could find besides iterating through each character
            - Bloctans
        ]]
        local ToSearch = string.reverse(string.sub(ScriptContents, 0,i-1))

        local Start, End = string.find(ToSearch, "[%w]+")
        local VarStart, VarEnd = #ToSearch - End, #ToSearch - Start
        local Var = string.sub(ScriptContents, VarStart+1, VarEnd+1)

        -- Now generate
        local Generated = Var.." = "..Var.." "..Operator
        table.insert(Replacements, {VarStart, i+2, Generated})
    end

    -- Find any `!=` comparision operator 
    for i,v in string.gfind(ScriptContents,  "[%!]=") do
        table.insert(Replacements, {i, i+2, "~="})
    end

    -- Find for tokens (for luau-like for loops) (TODO)

    -- Apply replacements from preprocessor parsing
    local GeneratedScript = ""
    local OldEnd = 0

    for _, v in pairs(Replacements) do
        local Start, End = v[1], v[2]
        local ReplaceWith = v[3]
        local Slice = string.sub(ScriptContents, OldEnd, Start)

        GeneratedScript = GeneratedScript..(Slice..ReplaceWith)
        OldEnd = End
    end

    GeneratedScript = GeneratedScript..string.sub(ScriptContents, OldEnd, -1)

    return GeneratedScript
end

return Preprocessor