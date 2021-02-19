local Character = require('src/characters/Character')

local PacerType = Class{__includes = Character}

PacerType.MOVEMENT_SPEED = 30
function PacerType:init(indexX, indexY, width, height, color, options)
    Character.init(self, indexX, indexY, width, height, color, options)

    self.noFriction = true

    self.directionMultiplier = -1
    self.velocity.x = self.MOVEMENT_SPEED * self.directionMultiplier

    self.fallOffEdges = false
    self.ceilingCrawl = false
end

function PacerType:update(dt)
    if ((self.directionMultiplier == -1) and self:shouldTurnAround()) then
        self.directionMultiplier = 1
        self:unflipHorizontal()
        for _, child in pairs(self.children) do
            child:unflipHorizontal()
        end
    elseif ((self.directionMultiplier == 1) and self:shouldTurnAround()) then
        self.directionMultiplier = -1
        self:flipHorizontal()
        for _, child in pairs(self.children) do
            child:flipHorizontal()
        end
    end
    self.velocity.x = self.MOVEMENT_SPEED * self.directionMultiplier
    Character.update(self, dt)
end

function PacerType:shouldTurnAround()
    if self.directionMultiplier == -1 then
        return (
            self:anyBlocksDirectlyLeft() or 
            ((not self.fallOffEdges) and (not self.ceilingCrawl) and (not self:anyBlockBelowAndLeft())) or
            ((not self.fallOffEdges) and (self.ceilingCrawl) and (not self:anyBlockAboveAndLeft()))
        )
    elseif self.directionMultiplier == 1 then
        return (
            self:anyBlocksDirectlyRight() or 
            ((not self.fallOffEdges) and (not self.ceilingCrawl) and (not self:anyBlockBelowAndRight())) or
            ((not self.fallOffEdges) and (self.ceilingCrawl) and (not self:anyBlockAboveAndRight()))
        )
    else
        return false
    end
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

function PacerType:anyBlockAboveAndRight()
    local block = GlobalState.subLevel:tileFromPoint({
        x = self.x + self.width,
        y = self.y - 1
    })
    return block and block.solid
end

function PacerType:anyBlockAboveAndLeft()
    local block = GlobalState.subLevel:tileFromPoint({
        x = self.x - 1,
        y = self.y - 1
    })
    return block and block.solid
end

return PacerType