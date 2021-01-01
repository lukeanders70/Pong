local PaddlerType = require('src/characters/PaddlerType')
local Paddle = require('src/objects/Paddle')

local Player = Class{__includes = PaddlerType}

Player.MAX_MOVEMENT_SPEED = 300
function Player:init(indexX, indexY)
    local width = 20
    local height = 64
    local color = {0, 10, 50, 255}

    PaddlerType.init(self, indexX, indexY, width, height, color, { health = 3, cursorPaddle = true })
    self.id = "player"
end

function Player:update(dt)
    self.acceleration.x = 0
    self.acceleration.y = 0
    if love.keyboard.isDown( 'a' ) then
        self:left()
    elseif love.keyboard.isDown( 'd' ) then
        self:right()
    end
    if love.keyboard.isDown( 'w' ) then
        self:jump()
    end
    self:capMovementSpeed()
    PaddlerType.update(self, dt)
end

function Player:capMovementSpeed()
    if self.velocity.x > Player.MAX_MOVEMENT_SPEED then
        self.velocity.x = Player.MAX_MOVEMENT_SPEED
    elseif self.velocity.x < (- Player.MAX_MOVEMENT_SPEED) then
        self.velocity.x = - Player.MAX_MOVEMENT_SPEED
    end

    if self.velocity.y > Player.MAX_MOVEMENT_SPEED then
        self.velocity.y = Player.MAX_MOVEMENT_SPEED
    elseif self.velocity.y < (- Player.MAX_MOVEMENT_SPEED) then
        self.velocity.y = - Player.MAX_MOVEMENT_SPEED
    end
end

function Player:characterCollide(collidable, dt)
    if not self.invincible then
        self:lowerHealth(1)
        local moveData = self:moveOutsideOf(collidable)
        if moveData.direction then
            self.velocity = vectorAdd(vectorScalerMultiply(moveData.direction, 500), self.velocity)
        end
        for _, child in pairs(self.children) do
            child:update(dt)
        end
    end
end

function Player:lowerHealth(amount)
    if not self.invincible then
        PaddlerType.lowerHealth(self, amount)
        self.invincible = true
        self.color[4] = 100
        Timer.after(1, function()
            self.color[4] = 255
            self.invincible = false
        end)
    end
end

function Player:left()
    if not self:anyBlocksDirectlyLeft() then
        self.acceleration.x = -2000
    end
end

function Player:right()
    if not self:anyBlocksDirectlyRight() then
        self.acceleration.x = 2000
    end
end

function Player:jump()
    if self:anyBlocksDirectlyBelow() then
        self.velocity.y = -1500
    end
end

return Player