return function(ScriptBytes, Identifier)
    local Contents = "return function()\n"..ScriptBytes.."\nend"
    
    local Function, Error = load(Contents, Identifier.ID, "t", {})

    if (not Function) then
        return load([[
            return function()
                print("Failed to compile script (]]..Identifier.ID..[[): "]]..Error..[[)

                return "Compilation failure"
            end
        ]], Identifier.ID, "t", {
            print = print
        })
    end

    return Function
end