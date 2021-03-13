local Character = require('src/characters/Character')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Blocker = Class{__includes = Character}

Blocker.MAX_MOVEMENT_SPEED = 100
Blocker.INDEX_RANGE = 10 -- the number of blocks (up and down) Blocker will fly to
function Blocker:init(indexX, indexY)

    Character.init(self, indexX, indexY, width, height, color, { gravity = false })
    self.width = 20
    self.height = 96

    self.image = ObjectTextureIndex.getImage('blocker', self.width, self.height)

    self.directionMultiplier = -1
    self.velocity.y = self.directionMultiplier * Blocker.MAX_MOVEMENT_SPEED
    self.startingIndex = indexY
end

function Blocker:update(dt)
    if self:anyBlocksDirectlyAbove() then
        self.directionMultiplier = 1
    elseif self:isOutOfIndexRangeUp() then
        self.directionMultiplier = 1
        self.y = ((self.startingIndex - Blocker.INDEX_RANGE) * Constants.TILE_SIZE)
    elseif self:anyBlocksDirectlyBelow() then
        self.directionMultiplier = -1
    elseif self:isOutOfIndexRangeDown() then 
        self.directionMultiplier = -1
        self.y = ((self.startingIndex + Blocker.INDEX_RANGE) * Constants.TILE_SIZE)
    end
    self.velocity.y = Blocker.MAX_MOVEMENT_SPEED * self.directionMultiplier
    Character.update(self, dt)
end

function Blocker:isOutOfIndexRangeDown()
    return self.y > ((self.startingIndex + Blocker.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Blocker:isOutOfIndexRangeUp()
    return self.y < ((self.startingIndex - Blocker.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Blocker