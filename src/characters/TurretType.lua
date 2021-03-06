local Character = require('src/characters/Character')
local Ball = require('src/objects/Ball')

local TurretType = Class{__includes = Character}

TurretType.FIRE_SPEED = 100
TurretType.SIGHT_RANGE = 12
TurretType.NUM_BOUNCES = 3
TurretType.FIRE_RATE = 2
function TurretType:init(indexX, indexY, options)
    local width = 20
    local height = 20
    local color = {255, 100, 100, 255}
    
    Character.init(self, indexX, indexY, width, height, color, { gravity = false })

    self.noFriction = true

    self.fireFrequency = (options and options.fireFrequency) or 3

    Timer.every(self.FIRE_RATE, function()
        if self.alive then
            self:attack()
        end
        return self.alive
    end):group(self.timerGroup)
end

function TurretType:update(dt)
    Character.update(self, dt)
end

function TurretType:attack()
    if GlobalState.level.player then
        local player = GlobalState.level.player
        local distance = vectorEuclidian(self:getCenter(), player:getCenter())
        local direction = vectorDirection(self:getCenter(), player:getCenter())
        if distance < (self.SIGHT_RANGE * Constants.TILE_SIZE) then
            local ball = Ball(
                self:getCenter().x,
                self:getCenter().y,
                {x = direction.x * self.FIRE_SPEED, y = direction.y * self.FIRE_SPEED},
                self.NUM_BOUNCES,
                {255, 255, 255, 255}
            )
            ball:moveOutsideOf(self, direction)
            ball.velocity = {x = direction.x * self.FIRE_SPEED, y = direction.y * self.FIRE_SPEED}
            GlobalState.subLevel:addObject(ball)
            ball:update(0.01) -- move it a little away so that if Flappy updates first it does not move into it and kill itself :(
            return true
        end
    end
    return false
end

return TurretType