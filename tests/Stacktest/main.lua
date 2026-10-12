local StackUntil = 0

function funny()
    if StackUntil < 32726 then
        print(StackUntil)
        StackUntil = StackUntil + 1
        funny()
    else
        print(debug.traceback())
    end
end

function love.load()
    funny()
end