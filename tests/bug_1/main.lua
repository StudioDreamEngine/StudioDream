Object = require("classic")
Things = require("example")

function print_table(tablea)
    print("New table")
    for i,v in pairs(tablea) do
        print(i,v)
    end
    print("End table")
end

function love.load()
    Things.Init()
end