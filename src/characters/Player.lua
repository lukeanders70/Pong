local Character = require('src/characters/Character')
local Paddle = require('src/objects/Paddle')

local Player = Class{__includes = Character}

Player.PADDLE_HEIGHT = 20
Player.MAX_MOVEMENT_SPEED = 300
function Player:init(indexX, indexY)
    local width = 20
    local height = 64
    local color = {0, 10, 50, 255}

    Character.init(self, indexX, indexY, width, height, color, {health=3})
    self.id = "player"
    self.paddleRight = Paddle(
        self,
        self.x + self.width - 1,
        self.y,
        self.width,
        0,
        Player.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255}
    )
    self.paddleLeft = Paddle(
        self,
        self.x - Paddle.PADDLE_WIDTH,
        self.y,
        - Paddle.PADDLE_WIDTH,
        0,
        Player.PADDLE_HEIGHT,
        {0, self.height},
        {255, 255, 255, 255}
    )

    GlobalState.level.collidables[self.paddleRight.id] = self.paddleRight
    GlobalState.level.collidables[self.paddleRight.id] = self.paddleLeft

    self.children = { self.paddleRight, self.paddleLeft }
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
    Character.update(self, dt)
    self.paddleRight:update(dt)
    self.paddleLeft:update(dt)
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

function Player:harmCollide(collidable, dt)
    local velocityBefore = {x = collidable.velocity.x, y = collidable.velocity.y}
    collidable:moveOutsideOf(self)
    collidable.velocity = velocityBefore
    local didCollide = self.paddleRight:conditionallyColide(collidable) or self.paddleLeft:conditionallyColide(collidable)
    if not didCollide then
        self:lowerHealth(1)
        collidable:destroy()
    end
end

function Player:characterCollide(collidable, dt)
    if not self.invincible then
        self:lowerHealth(1)
        local moveData = self:moveOutsideOf(collidable)
        if moveData.direction then
            self.velocity = vectorAdd(vectorScalerMultiply(moveData.direction, 1000), self.velocity)
        end
        for _, child in pairs(self.children) do
            child:update(dt)
        end
    end
end

function Player:lowerHealth(amount)
    if not self.invincible then
        Character.lowerHealth(self, amount)
        self.invincible = true
        self.color[4] = 100
        Timer.after(1, function()
            self.color[4] = 255
            self.invincible = false
        end)
    end
end

function Player:render()
    Character.render(self)
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