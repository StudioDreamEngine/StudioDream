return function(ScriptBytes, Identifier)
    local Contents = "return function()\n"..ScriptBytes.."\nend"
    
    local Function, Error = load(Contents, Identifier.ID, "t", {})

    if (not Function) then
        print(Error)

        local FallbackFunc, Error2 = load([[
            return function()
                print("Failed to Compile ]]..Identifier.ID..[[, see logs for details")
            
                return {}
            end
        ]], Identifier.ID, "t", {
            print = print,
            Error = Error
        })

        return FallbackFunc
    end

    return Function
end