local TurretType = require('src/characters/TurretType')
local Ball = require('src/objects/Ball')

local Flappy = Class{__includes = TurretType}

Flappy.MAX_MOVEMENT_SPEED = 50
Flappy.INDEX_RANGE = 2 -- the number of blocks (in each direction) flappies will fly to
Flappy.FIRE_SPEED = 100
Flappy.SIGHT_RANGE = 6
function Flappy:init(indexX, indexY)

    TurretType.init(self, indexX, indexY)

    self.directionMultiplier = -1
    self.velocity.x = self.directionMultiplier * Flappy.MAX_MOVEMENT_SPEED
    self.startingIndex = indexX
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
    TurretType.update(self, dt)
end

function Flappy:isOutOfIndexRangeLeft()
    return self.x < ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Flappy:isOutOfIndexRangeRight()
    return self.x > ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Flappy