local Directions = require('src/objects/Directions')

local Renderable = Class{}

function Renderable.fromImage(image, x, y)
    local r = Renderable(x, y, image.width, image.height)
    r.image = image
    return r
end

function Renderable:init(x, y, width, height)
    self.x = assert(x)
    self.y = assert(y)
    self.width = assert(width)
    self.height = assert(height)

    self.xScale = 1
    self.xRenderOffset = 0

    self.timerGroup = {}

    self.color = {255, 255, 255, 255}
end

function Renderable:upperLeft() return {x = self.x, y = self.y} end
function Renderable:upperRight() return {x = self.x + self.width - 1, y = self.y} end
function Renderable:lowerLeft() return {x = self.x, y = self.y + self.height - 1} end
function Renderable:lowerRight() return {x = self.x + self.width - 1, y = self.y + self.height - 1} end

function Renderable:getCenter(x, y)
    x = x or self.x
    y = y or self.y
    return {x = x + (0.5 * self.width), y = y + (0.5 * self.height)}
end

function Renderable:lowestIndexX()
    return math.floor( (self.x) / Constants.TILE_SIZE) + 1 
end

function Renderable:highestIndexX()
    return math.floor( (self.x + self.width) / Constants.TILE_SIZE) + 1
end

function Renderable:lowestIndexY()
    return math.floor( (self.y) / Constants.TILE_SIZE) + 1
end

function Renderable:highestIndexY()
    return math.floor( (self.y + self.height) / Constants.TILE_SIZE) + 1
end

function Renderable:pointInside(point)
    return (point.x <= self:upperRight().x) and
    (point.x >= self:upperLeft().x) and
    (point.y <= self:lowerRight().y) and
    (point.y >= self:upperRight().y)
end

function Renderable:flipHorizontal()
    self.xScale = -1
	self.xRenderOffset = self.width
end

function Renderable:unflipHorizontal()
    self.xScale = 1
	self.xRenderOffset = 0
end

function Renderable:update(dt)
    if #self.timerGroup > 0 then
        Timer.update(dt, self.timerGroup)
    end
end

function Renderable:destroy()
    Timer.clear(self.timerGroup)
end

function Renderable:render()
    love.graphics.setColor(unpack(self.color))
    if self.image then
        GlobalState.camera:draw(self.image.texture, self.image.quad, self.x, self.y, nil, nil, self.xScale, 1, self.xRenderOffset)
    else
        GlobalState.camera:rectangle(
            "fill",
            self.x,
            self.y,
            self.width,
            self.height
        )
    end
    love.graphics.setColor(255,255,255,255)
end

return Renderable
