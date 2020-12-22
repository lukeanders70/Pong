local Character = require('src/characters/Character')
local Paddle = require('src/objects/Paddle')

local Player = Class{__includes = Character}

Player.PADDLE_HEIGHT = 20
Player.MAX_MOVEMENT_SPEED = 300
function Player:init(indexX, indexY)
    local width = 20
    local height = 64
    local color = {0, 10, 50, 255}
    Character.init(self, indexX, indexY, width, height, color, {})

    self.paddle = Paddle(
        self.x + self.width - 1,
        self.y,
        self.width - 2,
        0,
        Player.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255}
    )
end

function Player:update(level, dt)
    self.acceleration.x = 0
    self.acceleration.y = 0
    if love.keyboard.isDown( 'a' ) then
        self:left(level)
    elseif love.keyboard.isDown( 'd' ) then
        self:right(level)
    end
    if love.keyboard.isDown( 'w' ) then
        self:jump(level)
    end
    self:capMovementSpeed()
    Character.update(self, level, dt)

    self.paddle:update(self.x, self.y, dt)
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

function Player:render()
    Character.render(self)

    self.paddle:render()
end

function Player:left(level)
    if not self:anyBlocksDirectlyLeft(level) then
        self.acceleration.x = -2000
    end
end

function Player:right(level)
    if not self:anyBlocksDirectlyRight(level) then
        self.acceleration.x = 2000
    end
end

function Player:jump(level)
    if self:anyBlocksDirectlyBelow(level) then
        self.velocity.y = -1500
    end
end

return Player