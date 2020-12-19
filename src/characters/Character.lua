local Physics = require('src/physics/Physics')
local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')

local Character = Class{__includes = Collidable}

Character.colliderType = ColliderTypes.CHARACTER
function Character:init(indexX, indexY, width, height, color, options)
    Collidable.init(self,
    {
        x = Constants.TILE_SIZE * (indexX - 1),
        y = Constants.TILE_SIZE * (indexY - 1),
        width = replaceIfNil(width, 1),
        height = replaceIfNil(height, 1)
    })
    self.color = color

    self.health = getOrElse(options, health, 1)
    self.gravity = getOrElse(options, "gravity", true)

    self.velocity = {x = 0, y = 0}
    self.acceleration = {x = 0, y = 0}
end

function Character:update(level, dt)
    if self.gravity and self:anyBlocksDirectlyBelow(level) then
        self.acceleration.y = 0
        self.velocity.y = math.min(self.velocity.y, 0)
    elseif self.gravity then
        self.acceleration.y = Physics.GRAVITY
    end
    Physics.update(self, dt)
    local collidables = self:getCollisionCandidates(level)
    Collidable.update(self, collidables)
end

function Character:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        return
    elseif collidable.colliderType == ColliderTypes.BLOCK then
        self:moveOutsideOf(collidable)
    elseif collidable.colliderType == ColliderTypes.HARM then
        self:lowerHealth(1)
    else
        logger("w", "Unhandled Collider type in Charater.lua: " .. tostring(collidable.colliderType))
    end
end

function Character:lowerHealth(amout)
    self.health = self.health - amout
    if self.health <= 0 then
        -- remove character
    end
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