return function(ScriptBytes, Identifier)
    local Contents = "return function()\n"..ScriptBytes.."\nend"

    return load(Contents, Identifier.ID, "t", {})
end