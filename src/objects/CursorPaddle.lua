local Paddle = require('src/objects/Paddle')
local ColliderTypes = require('src/objects/ColliderTypes')

local CursorPaddle = Class{__includes = Paddle}


CursorPaddle.FIDELITY = 0.3
CursorPaddle.BALL_FIRE_SPEED = 100
function CursorPaddle:init(parent, x, y, xOffset, yOffset, height, range, color, side)
    Paddle.init(self,
        parent,
        x,
        y,
        xOffset,
        yOffset,
        height,
        range,
        color,
        side
    )
    self.side = side or "left"
    self.associatedButtonNumber = 1
    if self.side == "right" then
        self.associatedButtonNumber = 2
    end
    self.capturedBall = nil
end

function CursorPaddle:collide(collidable)
    Paddle.collide(self, collidable)
    if collidable.colliderType == ColliderTypes.HARM then
        if love.mouse.isDown(self.associatedButtonNumber) and (self.capturedBall == nil) then
            self.capturedBall = collidable
            self.capturedBall.velocity = { x = 0, y = 0}
        end
    end
end

function CursorPaddle:conditinallyfireCapturedBall()
    if self.capturedBall and self.capturedBall.destroyed then
        self.capturedBall = nil
    end
    if (self.capturedBall ~= nil) and (not love.mouse.isDown(self.associatedButtonNumber)) then
        if self.side == "left" then
            self.capturedBall.x = self.capturedBall.x - 0.5
            self.capturedBall.velocity.x = self.velocity.x - CursorPaddle.BALL_FIRE_SPEED
            self.capturedBall.velocity.y = 0
        elseif self.side == "right" then
            self.capturedBall.x = self.capturedBall.x + 0.5
            self.capturedBall.velocity.x = self.velocity.x + CursorPaddle.BALL_FIRE_SPEED
            self.capturedBall.velocity.y = 0
        end
        self.capturedBall = nil
    end
end

function CursorPaddle:updateCapturedBall()
    if (self.capturedBall ~= nil) then
        if self.side == "left" then
            self.capturedBall.x = self.x - self.capturedBall.width
        elseif self.side == "right" then
            self.capturedBall.x = self.x + self.width
        end
        self.capturedBall.y = self.y + (self.height / 2) - (self.capturedBall.height / 2)
    end
end

function CursorPaddle:update(dt)
    local moveY = love.mouse.mousePositionGameY - love.mouse.lastMousePositionGameY
    Paddle.update(self, dt, moveY * self.FIDELITY)
    self:conditinallyfireCapturedBall()
    self:updateCapturedBall()
end

return CursorPaddle