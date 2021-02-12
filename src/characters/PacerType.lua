local Character = require('src/characters/Character')

local PacerType = Class{__includes = Character}

PacerType.MOVEMENT_SPEED = 30
function PacerType:init(indexX, indexY, width, height, color, options)
    Character.init(self, indexX, indexY, width, height, color, options)

    self.noFriction = true

    self.directionMultiplier = -1
    self.velocity.x = self.MOVEMENT_SPEED * self.directionMultiplier
end

function PacerType:update(dt)
    if (self.directionMultiplier == -1) and ((self:anyBlocksDirectlyLeft()) or (not self:anyBlockBelowAndLeft())) then
        self.directionMultiplier = 1
        self:unflipHorizontal()
        for _, child in pairs(self.children) do
            child:unflipHorizontal()
        end
    elseif (self.directionMultiplier == 1) and ((self:anyBlocksDirectlyRight()) or (not self:anyBlockBelowAndRight())) then
        self.directionMultiplier = -1
        self:flipHorizontal()
        for _, child in pairs(self.children) do
            child:flipHorizontal()
        end
    end
    self.velocity.x = self.MOVEMENT_SPEED * self.directionMultiplier
    Character.update(self, dt)
end

function PacerType:anyBlockBelowAndRight()
    local block = GlobalState.subLevel:tileFromPoint({
        x = self.x + self.width,
        y = self.y + self.height
    })
    return block and block.solid
end

function PacerType:anyBlockBelowAndLeft()
    local block = GlobalState.subLevel:tileFromPoint({
        x = self.x - 1,
        y = self.y + self.height
    })
    return block and block.solid
end

return PacerType