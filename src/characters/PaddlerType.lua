local Character = require('src/characters/Character')
local Paddle = require('src/objects/Paddle')

local PaddlerType = Class{__includes = Character}

PaddlerType.PADDLE_HEIGHT = 20
function PaddlerType:init(indexX, indexY, width, height, color, options)

    Character.init(self, indexX, indexY, width, height, color, options)
    self.paddleRight = Paddle(
        self,
        self.x + self.width - 1,
        self.y,
        self.width,
        0,
        PaddlerType.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255}
    )
    self.paddleLeft = Paddle(
        self,
        self.x - Paddle.PADDLE_WIDTH,
        self.y,
        - Paddle.PADDLE_WIDTH,
        0,
        PaddlerType.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255}
    )

    GlobalState.level.collidables[self.paddleRight.id] = self.paddleRight
    GlobalState.level.collidables[self.paddleRight.id] = self.paddleLeft

    self.children = { self.paddleRight, self.paddleLeft }
end

function PaddlerType:harmCollide(collidable, dt)
    local velocityBefore = {x = collidable.velocity.x, y = collidable.velocity.y}
    collidable:moveOutsideOf(self)
    collidable.velocity = velocityBefore
    local didCollide = self.paddleRight:conditionallyColide(collidable) or self.paddleLeft:conditionallyColide(collidable)
    if not didCollide then
        self:lowerHealth(1)
        collidable:destroy()
    end
end

return PaddlerType