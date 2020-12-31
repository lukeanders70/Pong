local PaddlerType = require('src/characters/PaddlerType')
local Paddle = require('src/objects/Paddle')

local PaddleBoy = Class{__includes = PaddlerType}

PaddleBoy.MOVEMENT_SPEED = 30
PaddleBoy.PADDLE_SPEED = 15
function PaddleBoy:init(indexX, indexY)
    local width = 20
    local height = 50
    local color = {255, 100, 100, 255}

    PaddlerType.init(self, indexX, indexY, width, height, color, {})

    self.noFriction = true

    self.paddleDirectionMultiplier = 1
    self.directionMultiplier = -1
    self.velocity.x = PaddleBoy.MOVEMENT_SPEED * self.directionMultiplier
end

function PaddleBoy:update(dt)
    if (self.directionMultiplier == -1) and (not self:anyBlockBelowAndLeft()) then
        self.directionMultiplier = 1
    elseif (self.directionMultiplier == 1) and (not self:anyBlockBelowAndRight()) then
        self.directionMultiplier = -1
    end
    self.velocity.x = PaddleBoy.MOVEMENT_SPEED * self.directionMultiplier
    self:updatePaddle(dt)
    PaddlerType.update(self, dt)
end

function PaddleBoy:updatePaddle(dt)
    if (self.paddleLeft.yOffset == self.paddleLeft.rangeMin) then
        self.paddleDirectionMultiplier = 1
    elseif (self.paddleLeft.yOffset == self.paddleLeft.rangeMax - self.paddleLeft.height) then
        self.paddleDirectionMultiplier = -1
    end
    self.paddleLeft:update(dt, self.paddleDirectionMultiplier * self.PADDLE_SPEED * dt)
    self.paddleRight:update(dt, self.paddleDirectionMultiplier * self.PADDLE_SPEED * dt)
end

function PaddleBoy:anyBlockBelowAndRight()
    local block = GlobalState.level:tileFromPoint({
        x = self.x + self.width,
        y = self.y + self.height
    })
    return block and block.solid
end

function PaddleBoy:anyBlockBelowAndLeft()
    local block = GlobalState.level:tileFromPoint({
        x = self.x - 1,
        y = self.y + self.height
    })
    return block and block.solid
end

return PaddleBoy