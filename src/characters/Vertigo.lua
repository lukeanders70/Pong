local TurretType = require('src/characters/TurretType')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')


local Vertigo = Class{__includes = TurretType}

Vertigo.MAX_MOVEMENT_SPEED = 40
Vertigo.INDEX_RANGE = 2 -- the number of blocks (up and down) vertigo will fly to
function Vertigo:init(indexX, indexY)

    TurretType.init(self, indexX, indexY)

    self.directionMultiplier = -1
    self.velocity.y = self.directionMultiplier * Vertigo.MAX_MOVEMENT_SPEED
    self.startingIndex = indexY

    self.staticImage = ObjectTextureIndex.getImage('vertigo', self.width, self.height)
    self.attackAnimation = ObjectTextureIndex.getAnimation('vertigo', self.width, self.height, self.timerGroup)

    self.image = self.staticImage
end

function Vertigo:update(dt)
    if self:isOutOfIndexRangeUp() or self:anyBlocksDirectlyAbove() then
        self.directionMultiplier = 1
        self.y = ((self.startingIndex - Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
    elseif self:isOutOfIndexRangeDown() or self:anyBlocksDirectlyBelow() then
        self.directionMultiplier = -1
        self.y = ((self.startingIndex + Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
    end
    self.velocity.y = Vertigo.MAX_MOVEMENT_SPEED * self.directionMultiplier
    TurretType.update(self, dt)
end

function Vertigo:attack()
    local didFire = TurretType.attack(self)
    if didFire then
        self.image = self.attackAnimation
        self.attackAnimation:cycleOnce(function()
            self.image = self.staticImage
        end)
    end
end

function Vertigo:isOutOfIndexRangeDown()
    return self.y > ((self.startingIndex + Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Vertigo:isOutOfIndexRangeUp()
    return self.y < ((self.startingIndex - Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Vertigo