local Character = require('src/characters/Character')
local Ball = require('src/objects/Ball')

local Flappy = Class{__includes = Character}

Flappy.MAX_MOVEMENT_SPEED = 50
Flappy.INDEX_RANGE = 2 -- the number of blocks (in each direction) flappies will fly to
Flappy.FIRE_SPEED = 100
function Flappy:init(indexX, indexY)
    local width = 20
    local height = 20
    local color = {255, 100, 100, 255}
    Character.init(self, indexX, indexY, width, height, color, { gravity = false })
    self.directionMultiplier = -1
    self.velocity.x = self.directionMultiplier * Flappy.MAX_MOVEMENT_SPEED
    self.startingIndex = indexX
    self.noFriction = true
    Timer.every(3, function()
        if self.alive then
            self:attack()
        end
        return self.alive
    end)
end

function Flappy:update(dt)
    if self:isOutOfIndexRangeLeft() or self:anyBlocksDirectlyLeft() then
        self.directionMultiplier = 1
        self.x = ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
    elseif self:isOutOfIndexRangeRight() or self:anyBlocksDirectlyRight() then
        self.directionMultiplier = -1
        self.x = ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
    end
    self.velocity.x = Flappy.MAX_MOVEMENT_SPEED * self.directionMultiplier
    Character.update(self, dt)
end

function Flappy:attack()
    if GlobalState.level.player then
        local player = GlobalState.level.player
        local direction = vectorDirection(self:getCenter(), player:getCenter())
        local ball = Ball(
            self:getCenter().x,
            self:getCenter().y,
            {x = direction.x * self.FIRE_SPEED, y = direction.y * self.FIRE_SPEED},
            3,
            {255, 255, 255, 255}
        )
        ball:moveOutsideOf(self, direction)
        ball.velocity = {x = direction.x * self.FIRE_SPEED, y = direction.y * self.FIRE_SPEED}
        GlobalState.level:addBall(ball)
        ball:update(0.01) -- move it a little away so that if Flappy updates first it does not move into it and kill itself :(
    end
end

function Flappy:isOutOfIndexRangeLeft()
    return self.x < ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Flappy:isOutOfIndexRangeRight()
    return self.x > ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Flappy