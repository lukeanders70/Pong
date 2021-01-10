local Physics = require('src/physics/Physics')
local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')

local Character = Class{__includes = Collidable}

function Character:init(indexX, indexY, width, height, color, options)
    Collidable.init(self,
    {
        x = Constants.TILE_SIZE * (indexX - 1),
        y = Constants.TILE_SIZE * (indexY - 1),
        width = replaceIfNil(width, 1),
        height = replaceIfNil(height, 1)
    })
    self.colliderType = ColliderTypes.CHARACTER
    self.alive = true
    self.color = color

    self.health = getOrElse(options, "health", 1)
    self.gravity = getOrElse(options, "gravity", true)

    self.velocity = {x = 0, y = 0}
    self.acceleration = {x = 0, y = 0}

    self.children = {}
end

function Character:update(dt)
    if self.gravity and self:anyBlocksDirectlyBelow() then
        self.acceleration.y = 0
        self.velocity.y = math.min(self.velocity.y, 0)
    elseif self.gravity then
        self.acceleration.y = Physics.GRAVITY
    end
    Physics.update(self, dt)
    for _, child in pairs(self.children) do
        child:update(dt)
    end
    if self:isOffScreenBottom() then
        self:destroy()
    end
end

function Character:collide(collidable, dt)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        self:characterCollide(collidable, dt)
    elseif collidable.colliderType == ColliderTypes.BLOCK then
        self:blockCollide(collidable, dt)
    elseif collidable.colliderType == ColliderTypes.HARM then
        self:harmCollide(collidable, dt)
    elseif collidable.colliderType == ColliderTypes.PADDLE then
        return
    else
        logger("w", "Unhandled Collider type in Charater.lua: " .. tostring(collidable.colliderType))
    end
end

function Character:characterCollide(collidable, dt)
    return
end

function Character:blockCollide(collidable, dt)
    self:moveOutsideOf(collidable)
    for _, child in pairs(self.children) do
        child:update(dt)
    end
end

function Character:harmCollide(collidable, dt)
    self:lowerHealth(1)
    collidable:destroy()
end

function Character:lowerHealth(amout)
    self.health = self.health - amout
    if self.health <= 0 then
        self:destroy()
    end
end

function Character:destroy()
    self.health = 0
    self.alive = false
    Collidable.destroy(self)
    for _, child in pairs(self.children) do
        child:destroy()
    end
end

function Character:render()
    Collidable.render(self)
    for _, child in pairs(self.children) do
        child:render()
    end
end

return Character