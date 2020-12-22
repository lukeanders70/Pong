local Character = require('src/characters/Character')

local Flappy = Class{__includes = Character}

Flappy.MAX_MOVEMENT_SPEED = 150
Flappy.INDEX_RANGE = 2 -- the number of blocks (in each direction) flappies will fly to
function Flappy:init(indexX, indexY)
    local width = 20
    local height = 20
    local color = {255, 100, 100, 255}
    Character.init(self, indexX, indexY, width, height, color, { gravity = false })
    self.directionMultiplier = -1
    self.velocity.x = self.directionMultiplier * Flappy.MAX_MOVEMENT_SPEED
    self.startingIndex = indexX
end

function Flappy:update(level, dt)
    if self:isOutOfIndexRangeLeft() or self:anyBlocksDirectlyLeft(level) then
        self.directionMultiplier = 1
    elseif self:isOutOfIndexRangeRight() or self:anyBlocksDirectlyRight(level) then
        self.directionMultiplier = -1
    end
    self.velocity.x = Flappy.MAX_MOVEMENT_SPEED * self.directionMultiplier
    Character.update(self, level, dt)
end

function Flappy:isOutOfIndexRangeLeft()
    return self.x < ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Flappy:isOutOfIndexRangeRight()
    return self.x > ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Flappy