local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local Physics = require('src/physics/Physics')

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
    self.color = color
    self.velocity = velocity
    self.colliderType = ColliderTypes.HARM
    self.bounces = bounces
    self.id = tostring(love.timer.getTime()) .. tostring(self.x) .. tostring(self.y)
    self.noFriction = true
end

function Ball:update(dt)
    if self:isfarAway(player) then
        self:destroy()
        return
    end
    Physics.update(self, dt)
    if self.acceleration.y > 0 then
        self.acceleration.y = math.max(self.acceleration.y - (self.ACCELERATION_DECAY * dt), 0)
    elseif self.acceleration.y < 0 then
        self.acceleration.y = math.min(self.acceleration.y + (self.ACCELERATION_DECAY * dt), 0)
    end 
end

function Ball:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        -- normally will result in damage to the character,
        -- and destruction of the ball, but we leave that to the character to determine
        return
    elseif (collidable.colliderType == ColliderTypes.BLOCK) or (collidable.colliderType == ColliderTypes.PADDLE) then
        self.acceleration.y = 0

        local velocityBefore = {x = self.velocity.x, y = self.velocity.y}
        local moveData = self:moveOutsideOf(collidable)
        self.velocity = velocityBefore

        self.bounces = self.bounces - 1
        if self.bounces < 0 then
            self:destroy()
        end
        
        if (moveData.axis == "x") or (moveData.axis == "y") then
            if sameSign({moveData.direction[moveData.axis], self.velocity[moveData.axis], collidable.velocity[moveData.axis]}) then
                self.velocity[moveData.axis] = collidable.velocity[moveData.axis] + self.velocity[moveData.axis]
            else
                self.velocity[moveData.axis] = collidable.velocity[moveData.axis] - self.velocity[moveData.axis]
            end
        else
            logger("w", "Ball collided with unrecognized axis: " .. tostring(axis))
        end 

        if collidable.velocity.y ~= 0 then
            self.acceleration.y = collidable.velocity.y * self.SPIN_COEFFICIENT
        end
    elseif collidable.colliderType == ColliderTypes.HARM then
        return
    else
        logger("w", "Unhandled Collider type in Ball.lua: " .. tostring(collidable.colliderType))
    end
end

function Ball:isfarAway()
    if GlobalState.level.player then
        if vectorEuclidian(self, GlobalState.level.player) > self.MAX_DISTANCE then
            return true
        else
            return false
        end
    else
        return true
    end
end

function Ball:destroy()
    GlobalState.level:destroy(self)
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

return Ball