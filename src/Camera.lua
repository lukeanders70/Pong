local Constants = require('src/Constants')

local Camera = Class{}

function Camera:init()
	self.x_offest = 0
	self.y_offset = 0

	self:setLimits()
end

function Camera:setX(newX)
	self.x_offest = math.min(math.max(-self.xMax, newX), -self.xMin)
end

function Camera:setY(newY)
	self.y_offset = math.min(math.max(-self.yMax, newY), -self.yMin)
end

function Camera:translate(dx, dy)
	self:setX(self.x_offest + dx)
	self:setY(self.y_offset + dy)
end

function Camera:returnToOrigin()
	self:setX(0)
	self:setY(0)
end

-- object must have x, y (in object coordinates), height, width
function Camera:centerOnObject(object, parent)
	local objectCenterX = nil
	local objectCenterY = nil
	if parent then
		objectCenterX = parent.x + object.x + (0.5 * object.width)
		objectCenterY = parent.y + object.y + (0.5 * object.height)
	else
		objectCenterX = object.x + (0.5 * object.width)
		objectCenterY = object.y + (0.5 * object.height)
	end

	self:setX((0.5 * Constants.VIRTUAL_WIDTH) - objectCenterX)
	self:setY((0.5 * Constants.VIRTUAL_HEIGHT) - objectCenterY)
end

function Camera:setLimits(limits)
	limits = limits or {}
	self.xMin = limits.xMin or  (-math.huge)
	self.xMax = limits.xMax or (math.huge)
	self.yMin = limits.yMin or (-math.huge)
	self.yMax = limits.yMax or (math.huge)
end

-- Given x and y in Camera Space (that is, where top-left of camera view is zero), convert to object coordinate plane space
function Camera:toObjectCoordinates(x, y)
	return x - self.x_offest, y - self.y_offset
end

-- draws the object to screen relative to camera position and, if present, parent position.
-- the parent object must have x and y value denoting its coordinates
function Camera:draw(tex, quad, x, y, parent, rotation, scaleX, scaleY, offsetX, originX, originY)
	if parent then
		love.graphics.drawScaled(
			tex,
			quad,
			x + self.x_offest + parent.x + (offsetX or 0),
			y + self.y_offset + parent.y,
			rotation,
			scaleX,
			scaleY,
			originX,
			originY
		)
	else
		love.graphics.drawScaled(
			tex,
			quad,
			x + self.x_offest + (offsetX or 0),
			y + self.y_offset,
			rotation,
			scaleX,
			scaleY,
			originX,
			originY
		)
	end
end


-- draws a rectangle to screen relative to camera position and, if present, parent position.
-- the parent object must have x and y value denoting its coordinates
function Camera:rectangle(type, x, y, width, height, cornerRadius, parent)
	if parent then
		love.graphics.rectangleScaled(type, x + self.x_offest + parent.x, y + self.y_offset + parent.y, width, height, cornerRadius)
	else
		love.graphics.rectangleScaled(type, x + self.x_offest, y + self.y_offset, width, height, cornerRadius)
	end
end

return Camera