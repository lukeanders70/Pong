local Character = require('src/characters/Character')

local RusherType = Class{__includes = Character}

RusherType.MOVEMENT_SPEED = 30
RusherType.MIN_DISTANCE = 0
RusherType.NOTICE_DISTANCE = 15 * Constants.TILE_SIZE
function RusherType:init(indexX, indexY, width, height)
    self.color = {255, 255, 255, 255}
    Character.init(self, indexX, indexY, width, height, self.color, {})
end

function RusherType:update(dt)
    if GlobalState.level.player then
        local player = GlobalState.level.player
        local directionToPlayer = vectorDirection(self:getCenter(), player:getCenter())
        local distanceToPlayer = vectorEuclidian(self:getCenter(), player:getCenter())
        if (distanceToPlayer > self.MIN_DISTANCE) and (distanceToPlayer < self.NOTICE_DISTANCE) then
            self.velocity = vectorScalerMultiply(directionToPlayer, self.MOVEMENT_SPEED)
        else
            self.velocity = {x = 0, y = 0}
        end
    else
        self.velocity = {x = 0, y = 0}
    end
    Character.update(self, dt)
end

return RusherType