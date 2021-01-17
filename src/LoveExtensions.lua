local Constants = require('src/Constants')

function love.graphics.drawScaled(tex, quad, x, y, rotation, scaleX, scaleY, originX, originY)
    love.graphics.draw(
        tex,
        quad,
        x * Constants.SCALE_MULTIPLIER,
        y * Constants.SCALE_MULTIPLIER,
        rotation,
        (scaleX or 1) * Constants.SCALE_MULTIPLIER,
        (scaleY or 1) * Constants.SCALE_MULTIPLIER,
        (originX or 0) * Constants.SCALE_MULTIPLIER,
        (originY or 0) * Constants.SCALE_MULTIPLIER
    )
end

function love.graphics.drawScaledNoQuad(tex, x, y, rotation, scaleX, scaleY, originX, originY)
    love.graphics.draw(
        tex,
        x * Constants.SCALE_MULTIPLIER,
        y * Constants.SCALE_MULTIPLIER,
        rotation,
        (scaleX or 1) * Constants.SCALE_MULTIPLIER,
        (scaleY or 1) * Constants.SCALE_MULTIPLIER,
        (originX or 0) * Constants.SCALE_MULTIPLIER,
        (originY or 0) * Constants.SCALE_MULTIPLIER
    )
end

function love.graphics.rectangleScaled(type, x, y, width, height, cornerRadius)
    love.graphics.rectangle(
        type,
        x * Constants.SCALE_MULTIPLIER,
        y * Constants.SCALE_MULTIPLIER,
        width * Constants.SCALE_MULTIPLIER,
        height * Constants.SCALE_MULTIPLIER,
        (cornerRadius or 0) * Constants.SCALE_MULTIPLIER

        
    )
end
