local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local Physics = require('src/physics/Physics')
local basicTextureIndex = require('src/textures/BasicTexturesIndex')

local Ball = Class{__includes = Collidable}

Ball.MAX_DISTANCE = Constants.TILE_SIZE * 20 -- in pixels
Ball.ACCELERATION_DECAY = 10
Ball.SPIN_COEFFICIENT = 0.5
function Ball:init(x, y, velocity, bounces, color)
    Collidable.init(self,
    {
        x = x,
        y = y,
        width = 4,
        height = 4
    })
    self.doesCollideWith = {
        [ColliderTypes.BLOCK] = true,
        [ColliderTypes.PADDLE] = true
    }

    self.color = color
    self.velocity = velocity
    self.colliderType = ColliderTypes.HARM
    self.bounces = bounces
    self.id = tostring(love.timer.getTime()) .. tostring(self.x) .. tostring(self.y)
    self.noFriction = true
    self.image = basicTextureIndex.smallBall
end

function Ball:update(dt)
    Physics.update(self, dt)
    if self.acceleration.y > 0 then
        self.acceleration.y = math.max(self.acceleration.y - (self.ACCELERATION_DECAY * dt), 0)
    elseif self.acceleration.y < 0 then
        self.acceleration.y = math.min(self.acceleration.y + (self.ACCELERATION_DECAY * dt), 0)
    end
end

function Ball:offscreenUpdate()
    self:destroy()
end

function Ball:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        -- normally will result in damage to the character,
        -- and destruction of the ball, but we leave that to the character to determine
        return
    elseif (collidable.colliderType == ColliderTypes.BLOCK) then
        self:blockCollide(collidable)
    elseif(collidable.colliderType == ColliderTypes.PADDLE) then
        self:paddleCollide(collidable)
    elseif collidable.colliderType == ColliderTypes.HARM then
        return
    elseif collidable.colliderType == ColliderTypes.INTERACT then
        return
    else
        logger("w", "Unhandled Collider type in Ball.lua: " .. tostring(collidable.colliderType))
    end
end

function Ball:blockCollide(collidable)
    self:bounceCollide(collidable)
end

function Ball:paddleCollide(collidable)
    self:bounceCollide(collidable)
end

function Ball:bounceCollide(collidable)
    self.acceleration.y = 0

    local velocityBefore = {x = self.velocity.x, y = self.velocity.y}
    local moveData = self:moveOutsideOf(collidable)
    self.velocity = velocityBefore

    self.bounces = self.bounces - 1
    if self.bounces < 0 then
        self:destroy()
    end
    if moveData and moveData.axis then
        if (moveData.axis == "x") or (moveData.axis == "y") then
            if sameSign({moveData.direction[moveData.axis], self.velocity[moveData.axis], collidable.velocity[moveData.axis]}) then
                self.velocity[moveData.axis] = collidable.velocity[moveData.axis] + self.velocity[moveData.axis]
            else
                self.velocity[moveData.axis] = collidable.velocity[moveData.axis] - self.velocity[moveData.axis]
            end
        else
            logger("w", "Ball collided with unrecognized axis: " .. tostring(axis))
        end 
    end

    if collidable.velocity.y ~= 0 then
        self.acceleration.y = collidable.velocity.y * self.SPIN_COEFFICIENT
    end
end

return Ball