local TurretType = require('src/characters/TurretType')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')


local Flappy = Class{__includes = TurretType}

Flappy.MAX_MOVEMENT_SPEED = 50
Flappy.INDEX_RANGE = 4 -- the number of blocks (in each direction) flappies will fly to
Flappy.FIRE_SPEED = 100
Flappy.SIGHT_RANGE = 12
function Flappy:init(indexX, indexY)

    TurretType.init(self, indexX, indexY)

    self.directionMultiplier = -1
    self.velocity.x = self.directionMultiplier * Flappy.MAX_MOVEMENT_SPEED
    self.startingIndex = indexX

    self.staticImage = ObjectTextureIndex.getImage('flappy', self.width, self.height)
    self.attackAnimation = ObjectTextureIndex.getAnimation('flappy-turn', self.width, self.height, self.timerGroup)

    self.image = self.staticImage
end

function Flappy:update(dt)
    if self:anyBlocksDirectlyAbove() then
        self.directionMultiplier = 1
    elseif self:isOutOfIndexRangeUp() then
        self.directionMultiplier = 1
        self.y = ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
    elseif self:anyBlocksDirectlyBelow() then
        self.directionMultiplier = -1
    elseif self:isOutOfIndexRangeDown() then 
        self.directionMultiplier = -1
        self.y = ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
    end
    self.velocity.x = Flappy.MAX_MOVEMENT_SPEED * self.directionMultiplier
    TurretType.update(self, dt)
end

function Flappy:attack()
    local didFire = TurretType.attack(self)
    if didFire then
        self.image = self.attackAnimation
        self.attackAnimation:cycleOnce(function()
            self.image = self.staticImage
        end)
    end
end

function Flappy:isOutOfIndexRangeLeft()
    return self.x < ((self.startingIndex - Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Flappy:isOutOfIndexRangeRight()
    return self.x > ((self.startingIndex + Flappy.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Flappy