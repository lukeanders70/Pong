local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')

local Paddle = Class{__includes = Collidable}


Paddle.FIDELITY = 0.3
function Paddle:init(parent, x, y, xOffset, yOffset, height, range, color)
    assert( (range[2] - range[1]) >= height)
    self.rangeMin = range[1]
    self.rangeMax = range[2]
    self.height = height
    self.xOffset = xOffset
    self.yOffset = self:setYOffset(yOffset)
    Collidable.init(self,
    {
        x = x,
        y = self.yOffset + y,
        width = 2,
        height = height
    })
    self.lastX = self.x
    self.lastY = self.y
    self.color = color
    self.parent = parent

    self.id = parent.id .. "-paddle"

    self.colliderType = ColliderTypes.PADDLE
end

function Paddle:update(dt)
    local moveY = love.mouse.mousePositionGameY - love.mouse.lastMousePositionGameY
    self:setYOffset(self.yOffset + (moveY * self.FIDELITY))
    self.lastX = self.x
    self.lastY = self.y
    self.x = self.parent.x + self.xOffset
    self.y = self.parent.y + self.yOffset
    self.velocity.x = self.parent.velocity.x
    -- velocity needs to account for parent velocity and the fact that we're moving the paddle with the cursor
    self.velocity.y = self.parent.velocity.y + ((self.y - self.lastY) / dt)
    self.acceleration = self.parent.acceleration
end

function Paddle:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        return
    elseif collidable.colliderType == ColliderTypes.BLOCK then
        return
    elseif collidable.colliderType == ColliderTypes.HARM then
        return
    else
        logger("w", "Unhandled Collider type in Charater.lua: " .. tostring(collidable.colliderType))
    end
end

function Paddle:setYOffset(newY)
    self.yOffset = math.min(math.max(newY, self.rangeMin), self.rangeMax - self.height)
    return self.yOffset
end

function Paddle:render()
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