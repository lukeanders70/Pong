local Character = require('src/characters/Character')
local Paddle = require('src/objects/Paddle')
local CursorPaddle = require('src/objects/CursorPaddle')


local PaddlerType = Class{__includes = Character}

PaddlerType.PADDLE_HEIGHT = 20
function PaddlerType:init(indexX, indexY, width, height, color, options)

    local paddleClass
    if options.cursorPaddle then
        paddleClass = CursorPaddle
    else
        paddleClass = Paddle
    end

    Character.init(self, indexX, indexY, width, height, color, options)
    self.paddleRight = paddleClass(
        self,
        self.x + self.width,
        self.y,
        self.width,
        0,
        PaddlerType.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255},
        "right"
    )
    self.paddleLeft = paddleClass(
        self,
        self.x - Paddle.PADDLE_WIDTH,
        self.y,
        - Paddle.PADDLE_WIDTH,
        0,
        PaddlerType.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255},
        "left"
    )

    GlobalState.level.collidables[self.paddleRight.id] = self.paddleRight
    GlobalState.level.collidables[self.paddleLeft.id] = self.paddleLeft

    self.children = { self.paddleRight, self.paddleLeft }
end

function PaddlerType:harmCollide(collidable, dt)
    -- local velocityBefore = {x = collidable.velocity.x, y = collidable.velocity.y}
    -- collidable:moveOutsideOf(self)
    -- collidable.velocity = velocityBefore
    -- local didCollide = self.paddleRight:conditionallyColide(collidable) or self.paddleLeft:conditionallyColide(collidable)
    -- if not didCollide then
    self:lowerHealth(1)
    collidable:destroy()
    -- end
end

return PaddlerType