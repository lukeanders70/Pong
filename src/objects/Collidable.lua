local ColliderTypes = require('src/objects/ColliderTypes')
local Directions = require('src/objects/Directions')

local Collidable = Class{}

function Collidable:init(params)
    self.colliderType = ColliderTypes.BLOCK
    self.solid = true

    self.x = assert(params.x)
    self.y = assert(params.y)
    self.width = assert(params.width)
    self.height = assert(params.height)

    self.velocity = {x = 0, y = 0}
    self.acceleration = {x = 0, y = 0}

    self.id = tostring(self.x) .. tostring(self.y)
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

function Collidable:anyBlocksDirectlyBelow()
    local pixelsToCheck = {}
    local PixelToAddX = self:lowerLeft().x

    while PixelToAddX < self:lowerRight().x do
        table.insert(pixelsToCheck, {x = PixelToAddX, y = self:lowerRight().y + 1})
        PixelToAddX = PixelToAddX + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x, y = self:lowerRight().y + 1})

    return self:checkCollidableFromPoints(pixelsToCheck)
end

function Collidable:anyBlocksDirectlyLeft()
    local pixelsToCheck = {}
    local PixelToAddY = self:upperLeft().y

    while PixelToAddY < self:lowerLeft().y do
        table.insert(pixelsToCheck, {x = self:upperLeft().x - 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerLeft().x - 1, y = self:lowerLeft().y})

    return self:checkCollidableFromPoints(pixelsToCheck)
end

function Collidable:anyBlocksDirectlyRight()
    local pixelsToCheck = {}
    local PixelToAddY = self:upperRight().y

    while PixelToAddY < self:lowerRight().y do
        table.insert(pixelsToCheck, {x = self:upperRight().x + 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x + 1, y = self:lowerRight().y})

    return self:checkCollidableFromPoints(pixelsToCheck)
end

function Collidable:checkCollidableFromPoints(pixelsToCheck)
    for _, checkpoint in pairs(pixelsToCheck) do
        local tile = GlobalState.level:tileFromPoint(checkpoint)
        if tile and tile.solid then
            return tile
        end
    end
    return false
end

function Collidable:moveOutsideOf(collidable, direction)
    if self:intersect(collidable) then

        local directionOut -- default (should never be used)

        if direction then
            directionOut = direction
        elseif not ((self.velocity.x == 0) and (self.velocity.y == 0)) then
            directionOut = { x = -self.velocity.x, y = -self.velocity.y }
        -- otherwise, move out directly away from the object's center
        elseif (collidable.velocity and (collidable.velocity.x ~= 0) and (collidable.velocity.y ~= 0)) then
            directionOut = { x = collidable.velocity.x, y = collidable.velocity.y }
        else
            local center = self:getCenter()
            directionOut = vectorNormalize(vectorSub(center, collidable:getCenter()))
        end

        local multOptions = {
            { axis = 'x', mult = (collidable.x - self.x - self.width) / directionOut.x }, -- move out to left of collidable
            { axis = 'x', mult = (collidable.x + collidable.width - self.x) / directionOut.x }, -- move out to right of collidable
            { axis = 'y', mult = (collidable.y - self.y - self.height) / directionOut.y }, -- move out on top of collidable
            { axis = 'y', mult = (collidable.y + collidable.height - self.y) / directionOut.y } -- move out on bottom of collidable
        }

        -- also tests if it's infinity, negative infinity, or NaN
        local multOptionsGreaterThanZero = table.filter(multOptions, function(k, mult) 
            return (mult.mult ~= nil) and (mult.mult > 0) and (not (mult.mult == math.huge)) and (not (mult.mult == -math.huge)) and (not (mult.mult ~= mult.mult))
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
                return 'x'
            elseif multiplier.axis == 'y' and self.velocity and self.acceleration then
                self.velocity.y = 0
                self.acceleration.y = 0
                self.lastY = self.y
                return 'y'
            end
        else
            logger("w", "unable to moveOutSideOf in collision case")
        end
    end
    return nil
end

function Collidable:getCollisionCandidates(excludeBlocks)
    local priorityCandidates = table.filter(GlobalState.level.priorityCollidables, function(k,v)
        return (not (v == self)) and (not (startsWith(v.id, self.id .. '-')))
    end)
    local regularcandidates = table.filter(GlobalState.level.collidables, function(k,v)
        return (not (v == self)) and (not (startsWith(v.id, self.id .. '-')))
    end)
    local candidates = table.concat(priorityCandidates, regularcandidates)
    if not excludeBlocks then
        -- add surrounding blocks
        local lowestIndexX = math.floor( (self.x) / Constants.TILE_SIZE) + 1 
        local highestIndexX = math.floor( (self.x + self.width) / Constants.TILE_SIZE) + 1

        local lowestIndexY = math.floor( (self.y) / Constants.TILE_SIZE) + 1
        local highestIndexY = math.floor( (self.y + self.height) / Constants.TILE_SIZE) + 1

        for indexX = lowestIndexX, highestIndexX do
            for indexY = lowestIndexY, highestIndexY do
                if GlobalState.level.tiles[indexX] and GlobalState.level.tiles[indexX][indexY] then
                    table.insert(candidates, GlobalState.level.tiles[indexX][indexY])
                end
            end
        end
    end
    return candidates
end

return Collidable
