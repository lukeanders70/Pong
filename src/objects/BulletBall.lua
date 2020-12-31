local Ball = require('src/objects/Ball')
local ColliderTypes = require('src/objects/ColliderTypes')
local Physics = require('src/physics/Physics')

local BulletBall = Class{__includes = Ball}

function BulletBall:init(x, y, velocity, bounces, color)
    Ball.init(self,
        x,
        y,
        velocity,
        bounces,
        color
    )
end

function BulletBall:blockCollide(collidable)
    self:destroy()
end

return BulletBall