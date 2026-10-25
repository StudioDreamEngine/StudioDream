return function(Info)
    local Size = Info.Size
    local CornerRadius = Info.CornerRadius
    local Outline = Info.Outline

    Runtime.Backend2D.SetColor(Info.Color)

    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, CornerRadius, CornerRadius)
    
    if Outline and Outline.Size > 0 then
        love.graphics.setLineWidth(Outline.Size)
        Runtime.Backend2D.SetColor(Outline.Color)
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y, CornerRadius, CornerRadius)
    end
end