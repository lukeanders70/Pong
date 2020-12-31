local Paddle = require('src/objects/Paddle')

local CursorPaddle = Class{__includes = Paddle}


CursorPaddle.FIDELITY = 0.3
function CursorPaddle:init(parent, x, y, xOffset, yOffset, height, range, color)
    Paddle.init(self,
        parent,
        x,
        y,
        xOffset,
        yOffset,
        height,
        range,
        color
    )
end

function CursorPaddle:update(dt)
    local moveY = love.mouse.mousePositionGameY - love.mouse.lastMousePositionGameY
    Paddle.update(self, dt, moveY * self.FIDELITY)
end

return CursorPaddle