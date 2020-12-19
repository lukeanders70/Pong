local ColliderTypes = require('src/objects/ColliderTypes')
local Directions = require('src/objects/Directions')

local Collidable = Class{}

function Collidable:init(params)
    self.colliderType = ColliderTypes.BLOCK
    self.solid = true

    self.x = assert(params.x)
    self.y = assert(params.y)
    self.lastX = x
    self.lastY = y
    self.width = assert(params.width)
    self.height = assert(params.height)
end

function Collidable:upperLeft() return {x = self.x, y = self.y} end
function Collidable:upperRight() return {x = self.x + self.width - 1, y = self.y} end
function Collidable:lowerLeft() return {x = self.x, y = self.y + self.height - 1} end
function Collidable:lowerRight() return {x = self.x + self.width - 1, y = self.y + self.height - 1} end

function Collidable:conditionallyColide(collidable)
    if self.solid and collidable.solid and self:intersect(collidable) then
        collidable:collide(self)
        self:collide(collidable)
    end
end

function Collidable:collide(Collidable)
    return
end

function Collidable:update(collidables)
    for _, collidable in pairs(collidables) do
        self:conditionallyColide(collidable)
    end
end

function Collidable:getCenter(x, y)
    x = x or self.x
    y = y or self.y
    return {x = x + (0.5 * self.width), y = y + (0.5 * self.height)}
end

function Collidable:intersect(col2)
    retVal = not (
        ( math.ceil(self:lowerLeft().y) < col2:upperLeft().y ) or -- above
        ( math.floor(self:upperLeft().y) > col2:lowerLeft().y ) or -- below
        ( math.ceil(self:lowerRight().x) < col2:lowerLeft().x ) or -- left
        ( math.floor(self:lowerLeft().x) > col2:lowerRight().x ) -- right
    )
    if retVal and (not everCalled) then
        everCalled = 1
    elseif retVal then
        everCalled = everCalled + 1
    end

    return retVal
end

function Collidable:anyBlocksDirectlyBelow(level)
    local pixelsToCheck = {}
    local PixelToAddX = self:lowerLeft().x

    while PixelToAddX < self:lowerRight().x do
        table.insert(pixelsToCheck, {x = PixelToAddX, y = self:lowerRight().y + 1})
        PixelToAddX = PixelToAddX + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x, y = self:lowerRight().y + 1})

    return self:checkCollidableFromPoints(pixelsToCheck, level)
end

function Collidable:anyBlocksDirectlyLeft(level)
    local pixelsToCheck = {}
    local PixelToAddY = self:upperLeft().y

    while PixelToAddY < self:lowerLeft().y do
        table.insert(pixelsToCheck, {x = self:upperLeft().x - 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerLeft().x - 1, y = self:lowerLeft().y})

    return self:checkCollidableFromPoints(pixelsToCheck, level)
end

function Collidable:anyBlocksDirectlyRight(level)
    local pixelsToCheck = {}
    local PixelToAddY = self:upperRight().y

    while PixelToAddY < self:lowerRight().y do
        table.insert(pixelsToCheck, {x = self:upperRight().x + 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x + 1, y = self:lowerRight().y})

    return self:checkCollidableFromPoints(pixelsToCheck, level)
end

function Collidable:checkCollidableFromPoints(pixelsToCheck, level)
    for _, checkpoint in pairs(pixelsToCheck) do
        local tile = level:tileFromPoint(checkpoint)
        if tile and tile.solid then
            return tile
        end
    end
    return false
end

function Collidable:moveOutsideOf(collidable)
    local center = self:getCenter()
    local oldCenter = self:getCenter(self.lastX, self.lastY)

    local directionOut -- default (should never be used)
    -- if possible, move out the way we moved in
    if not ((oldCenter.x == center.x) and (oldCenter.y == center.y)) then
        directionOut = vectorNormalize(vectorSub(oldCenter, center))
    -- otherwise, move out directly away from the object's center
    else
        directionOut = vectorNormalize(vectorSub(center, collidable:getCenter()))
    end

    local multOptions = {
        { axis = 'x', mult = (collidable.x - self.x - self.width) / directionOut.x }, -- move out to left of collidable
        { axis = 'x', mult = (collidable.x + collidable.width - self.x) / directionOut.x }, -- move out to right of collidable
        { axis = 'y', mult = (collidable.y - self.y - self.height) / directionOut.y }, -- move out on top of collidable
        { axis = 'y', mult = (collidable.y + collidable.height - self.y) / directionOut.y } -- move out on bottom of collidable
    }

    local multOptionsGreaterThanZero = table.filter(multOptions, function(k, mult) 
        return mult.mult and (mult.mult > 0)
    end)

    local multiplier = table.min(multOptionsGreaterThanZero, function(mult) 
        return mult.mult
    end)

    if multiplier then
        self.x = self.x + (multiplier.mult * directionOut.x)
        self.y = self.y + (multiplier.mult * directionOut.y)

        if (multiplier.axis == 'x') and self.velocity and self.acceleration then
            self.velocity.x = 0
            self.acceleration.x = 0
            self.lastX = self.x
        elseif multiplier.axis == 'y' and self.velocity and self.acceleration then
            self.velocity.y = 0
            self.acceleration.y = 0
            self.lastY = self.y
        end
    end
end

function Collidable:getCollisionCandidates(level)
    local candidates = table.filter(level.collidables, function(k,v)
        return not (v == self)
    end)
    -- add surrounding blocks
    local lowestIndexX = math.floor( (self.x) / Constants.TILE_SIZE) + 1 
    local highestIndexX = math.floor( (self.x + self.width) / Constants.TILE_SIZE) + 1

    local lowestIndexY = math.floor( (self.y) / Constants.TILE_SIZE) + 1
    local highestIndexY = math.floor( (self.y + self.height) / Constants.TILE_SIZE) + 1

    for indexX = lowestIndexX, highestIndexX do
        for indexY = lowestIndexY, highestIndexY do
            if level.tiles[indexX] and level.tiles[indexX][indexY] then
                table.insert(candidates, level.tiles[indexX][indexY])
            end
        end
    end
    return candidates
end

return Collidable
