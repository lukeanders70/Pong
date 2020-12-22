local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local Physics = require('src/physics/Physics')

local Ball = Class{__includes = Collidable}

function Ball:init(x, y, velocity, bounces, color, level)
    self.level = level
    self.color = color
    self.velocity = velocity
    Collidable.init(self,
    {
        x = x,
        y = y,
        width = 2,
        height = 2
    })
    self.colliderType = ColliderTypes.HARM
    self.bounces = bounces
    self.id = tostring(love.timer.getTime()) + tostring(self.x) + tostring(self.y)
end

function Ball:update(dt)
    Physics.update(self, dt)
    local collidables = self:getCollisionCandidates(self.level)
    Collidable.update(self, collidables)
end

function Ball:collide(level, collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        -- normally will result in damage to the character, but we leave that to the character to determine
        self:destroy(level)
    elseif (collidable.colliderType == ColliderTypes.BLOCK) or (collidable.colliderType == ColliderTypes.PADDLE) then
        local axis = self:moveOutsideOf(collidable)
        if axis then
            if axis == "x" then
                self.velocity.x = - self.velocity.x
            elseif axis == "y" then
                self.velocity.y = - self.velocity.y
            else
                logger("w", "Ball collided with unrecognized axis: " .. tostring(axis))
            end 
        end
    elseif collidable.colliderType == ColliderTypes.HARM then
        return
    else
        logger("w", "Unhandled Collider type in Ball.lua: " .. tostring(collidable.colliderType))
    end
end

function Ball:destroy(level)
    level:destroy(self)
end

function Ball:render()
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

return Paddle