local Character = require('src/characters/Character')
local Ball = require('src/objects/Ball')

local Vertigo = Class{__includes = Character}

Vertigo.MAX_MOVEMENT_SPEED = 40
Vertigo.INDEX_RANGE = 1 -- the number of blocks (up and down) vertigo will fly to
Vertigo.FIRE_SPEED = 100
Vertigo.SIGHT_RANGE = 6
function Vertigo:init(indexX, indexY)
    local width = 20
    local height = 20
    local color = {255, 100, 100, 255}
    Character.init(self, indexX, indexY, width, height, color, { gravity = false })
    self.directionMultiplier = -1
    self.velocity.y = self.directionMultiplier * Vertigo.MAX_MOVEMENT_SPEED
    self.startingIndex = indexY
    self.noFriction = true
    Timer.every(3, function()
        if self.alive then
            self:attack()
        end
        return self.alive
    end)
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
    Character.update(self, dt)
end

function Vertigo:attack()
    if GlobalState.level.player then
        local player = GlobalState.level.player
        local distance = vectorEuclidian(self:getCenter(), player:getCenter())
        local direction = vectorDirection(self:getCenter(), player:getCenter())
        if distance < (Vertigo.SIGHT_RANGE * Constants.TILE_SIZE) then
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
end

function Vertigo:isOutOfIndexRangeDown()
    return self.y > ((self.startingIndex + Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
end

function Vertigo:isOutOfIndexRangeUp()
    return self.y < ((self.startingIndex - Vertigo.INDEX_RANGE) * Constants.TILE_SIZE)
end

return Vertigo