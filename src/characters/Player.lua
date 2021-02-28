local PaddlerType = require('src/characters/PaddlerType')
local Paddle = require('src/objects/Paddle')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Player = Class{__includes = PaddlerType}

Player.TEXTURE_PATH = ''
Player.MAX_MOVEMENT_SPEED_VERTICAL = 2000
Player.MAX_MOVEMENT_SPEED_HORIZONTAL = 200

function Player:init(indexX, indexY)
    local width = 20
    local height = 64
    local color = {0, 10, 50, 255}

    PaddlerType.init(self, indexX, indexY, width, height, color, { health = 3, cursorPaddle = true })
    self.id = "player"
    self.staticImage = ObjectTextureIndex.getImage('player', self.width, self.height)
    self.moveAnimation = ObjectTextureIndex.getAnimation('player-walk', self.width, self.height, self.timerGroup)
    self.spinAnimation = ObjectTextureIndex.getAnimation('player-spin', self.width, self.height, self.timerGroup)
    self.spinAnimation.frameDelay = 0.05

    self.image = self.staticImage

    self.doubleJumped = true

    self.levelComplete = false
end

function Player:update(dt)
    self.acceleration.x = 0
    self.acceleration.y = 0

    self.anyBlocksBelowThisFrame = self:anyBlocksDirectlyBelow()
    
    -- for when keys are held down
    if not self.levelComplete then
        if love.keyboard.isDown( 'a' ) then
            if (self.image ~= self.moveAnimation) and self.anyBlocksBelowThisFrame then 
                self.image = self.moveAnimation
                self.moveAnimation:continousCycling()
            end
            self:flipHorizontal()
            self:left()
        elseif love.keyboard.isDown( 'd' ) then
            if (self.image ~= self.moveAnimation) and self.anyBlocksBelowThisFrame then 
                self.image = self.moveAnimation
                self.moveAnimation:continousCycling()
            end
            self:unflipHorizontal()
            self:right()
        elseif (self.image == self.moveAnimation) then
            self.image = self.staticImage
            self.moveAnimation:stopCycle()
        end
        if love.keyboard.isDown( 'w' ) then
            self:struggleUp()
        end
    end
    self:capMovementSpeed()
    self:capPosition()
    PaddlerType.update(self, dt)
end

-- for when keys are pressed
function Player:inputHandleKeyPress(key)
    if not self.levelComplete then
        if key == 'w' then
            self:jump()
            self:keyUp()
        elseif key == 's' then
            self:keyDown()
        end
    end
end

function Player:setLevelComplete()
    self.levelComplete = true
    self.image = self.spinAnimation
    self.image:cycleOnce()
end

function Player:capMovementSpeed()
    if self.velocity.x > Player.MAX_MOVEMENT_SPEED_HORIZONTAL then
        self.velocity.x = Player.MAX_MOVEMENT_SPEED_HORIZONTAL
    elseif self.velocity.x < (- Player.MAX_MOVEMENT_SPEED_HORIZONTAL) then
        self.velocity.x = - Player.MAX_MOVEMENT_SPEED_HORIZONTAL
    end

    if self.velocity.y > Player.MAX_MOVEMENT_SPEED_VERTICAL then
        self.velocity.y = Player.MAX_MOVEMENT_SPEED_VERTICAL
    elseif self.velocity.y < (- Player.MAX_MOVEMENT_SPEED_VERTICAL) then
        self.velocity.y = - Player.MAX_MOVEMENT_SPEED_VERTICAL
    end
end

function Player:capPosition()
    if self.x < 0 then
        self.velocity.x = 0
        self.acceleration.x = 0
        self.x = 0
    elseif self.x + self.width > GlobalState.subLevel.xMax then
        self.velocity.x = 0
        self.acceleration.x = 0
        self.x = GlobalState.subLevel.xMax - self.width
    end
end

function Player:characterCollide(collidable, dt)
    if not self.invincible then
        self:lowerHealth(1)
        local moveData = self:moveOutsideOf(collidable)
        if moveData and moveData.direction then
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

function Player:setPos(indexX, indexY)
    self.x = Constants.TILE_SIZE * (indexX - 1)
    self.y = Constants.TILE_SIZE * (indexY - 1)
    self.velocity.x = 0
    self.velocity.y = 0
    self.acceleration.x = 0
    self.acceleration.y = 0
    for _, child in pairs(self.children) do
        child:update(1)
    end
end

function Player:destroy()
    PaddlerType.destroy(self)
    GlobalState.level:levelFailed()
end

function Player:left()
    if not self:anyBlocksDirectlyLeft() then
        self.acceleration.x = -1500
    end
end

function Player:right()
    if not self:anyBlocksDirectlyRight() then
        self.acceleration.x = 1500
    end
end

-- when jumping, allows holding up to increase jump height
function Player:struggleUp()
    if self.velocity.y < 0 and (not self.doubleJumped) and (not self.anyBlocksBelowThisFrame) then
        self.acceleration.y = -900
    end
end

function Player:jump()
    if self:anyBlocksDirectlyBelow() then
        self.velocity.y = -300
        self.doubleJumped = false
    elseif not self.doubleJumped then
        self.image = self.spinAnimation
        self.image:cycleOnce()
        self.velocity.y = -300
        self.doubleJumped = true
    end
end

function Player:keyDown()
    local objects = self:getObjectsDirectlyBelow()
    for _, object in pairs(objects) do
        if object.downTrigger then
            object:downTrigger()
        end
    end
end

function Player:keyUp()
    local objects = self:getObjectsNearlyAbove()
    for _, object in pairs(objects) do
        if object.upTrigger then
            object:upTrigger()
        end
    end
end

function Player:addHealth()
    if self.health == 3 then
        return
    else
        self.health = self.health + 1
    end
end

return Player