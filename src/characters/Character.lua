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

    self.health = getOrElse(options, health, 1)
    self.gravity = getOrElse(options, "gravity", true)

    self.velocity = {x = 0, y = 0}
    self.acceleration = {x = 0, y = 0}
end

function Character:update(dt)
    if self.gravity and self:anyBlocksDirectlyBelow() then
        self.acceleration.y = 0
        self.velocity.y = math.min(self.velocity.y, 0)
    elseif self.gravity then
        self.acceleration.y = Physics.GRAVITY
    end
    Physics.update(self, dt)
end

function Character:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        return
    elseif collidable.colliderType == ColliderTypes.BLOCK then
        self:moveOutsideOf(collidable)
        return
    elseif collidable.colliderType == ColliderTypes.HARM then
        if (self.harmCollide) and (type(self.harmCollide) == "function") then
            self:harmCollide(collidable)
        else
            self:lowerHealth(1)
            collidable:destroy()
        end
        return
    elseif collidable.colliderType == ColliderTypes.PADDLE then
        return
    else
        logger("w", "Unhandled Collider type in Charater.lua: " .. tostring(collidable.colliderType))
    end
end

function Character:lowerHealth(amout)
    self.health = self.health - amout
    if self.health <= 0 then
        self:kill()
    end
end

function Character:kill()
    self.alive = false
    GlobalState.level:destroy(self)
end

function Character:render()
    love.graphics.setColor(unpack(self.color))
    GlobalState.camera:rectangle(
        "fill",
        self.x,
        self.y,
        self.width,
        self.height
    )
    love.graphics.setColor(255,255,255,255)
end

return Character