return function(table)
    local Index = 0

    return function()
        Index = Index + 1
        local Val = table[Index]

        if Val ~= nil then
            return Index, Val
        end
    end
end