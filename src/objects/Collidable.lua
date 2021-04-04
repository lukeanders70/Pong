local ColliderTypes = require('src/objects/ColliderTypes')
local Directions = require('src/objects/Directions')
local Renderable = require('src/objects/Renderable')

local Collidable = Class{__includes = Renderable}

function Collidable:init(params)
    self.colliderType = ColliderTypes.BLOCK

    -- by default we collide with all types
    self.doesCollideWith = {}
    for _, type in pairs(ColliderTypes) do
        self.doesCollideWith[type] = true
    end

    self.solid = true

    Renderable.init(self, params.x, params.y, params.width, params.height)

    self.velocity = {x = 0, y = 0}
    self.acceleration = {x = 0, y = 0}

    self.destroyed = false

    self.id = tostring(self.x) .. tostring(self.y)
end

function Collidable:conditionallyColide(collidable, dt)
    if self.solid and collidable.solid and self:intersect(collidable) then
        collidable:collide(self, dt)
        self:collide(collidable, dt)
        return true
    end
    return false
end

function Collidable:collide(Collidable)
    return
end

function Collidable:updateCollisions(dt, collidables)
    if not collidables then
        collidables = self:getCollisionCandidates()
    end
    for _, collidable in pairs(collidables) do
        self:conditionallyColide(collidable, dt)
    end
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

function Collidable:isOffScreenBottom()
    return self:lowerLeft().y > GlobalState.subLevel.yMax
end

function Collidable:anyBlocksDirectlyBelow()
    return #self:getObjectsDirectlyBelow() > 0
end

function Collidable:getObjectsDirectlyBelow()
    local pixelsToCheck = {}
    local PixelToAddX = self:lowerLeft().x

    while PixelToAddX < self:lowerRight().x do
        table.insert(pixelsToCheck, {x = PixelToAddX, y = self:lowerRight().y + 1})
        PixelToAddX = PixelToAddX + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x, y = self:lowerRight().y + 1})

    return self:getCollidablesFromPoints(pixelsToCheck)
end

function Collidable:getObjectsNearlyAbove()
    local pixelsToCheck = {}
    local PixelToAddX = self:upperLeft().x

    while PixelToAddX < self:upperRight().x do
        -- five because we're looking a little higher than directly above
        table.insert(pixelsToCheck, {x = PixelToAddX, y = self:upperLeft().y - 5})
        PixelToAddX = PixelToAddX + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:upperRight().x, y = self:upperRight().y - 10})

    return self:getCollidablesFromPoints(pixelsToCheck)
end

function Collidable:anyBlocksDirectlyAbove()
    local pixelsToCheck = {}
    local PixelToAddX = self:upperLeft().x

    while PixelToAddX < self:upperRight().x do
        table.insert(pixelsToCheck, {x = PixelToAddX, y = self:upperRight().y - 1})
        PixelToAddX = PixelToAddX + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x, y = self:upperRight().y - 1})

    return #self:getCollidablesFromPoints(pixelsToCheck) > 0
end

function Collidable:isDirectlyAbove(collidable)
    return collidable:pointInside({x = self.x, y = self.y - 1}) or collidable:pointInside({x = self.x + self.width, y = self.y - 1})
end

function Collidable:anyBlocksDirectlyLeft()
    local pixelsToCheck = {}
    local PixelToAddY = self:upperLeft().y

    while PixelToAddY < self:lowerLeft().y do
        table.insert(pixelsToCheck, {x = self:upperLeft().x - 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerLeft().x - 1, y = self:lowerLeft().y})

    return #self:getCollidablesFromPoints(pixelsToCheck) > 0
end

function Collidable:anyBlocksDirectlyRight()
    local pixelsToCheck = {}
    local PixelToAddY = self:upperRight().y

    while PixelToAddY < self:lowerRight().y do
        table.insert(pixelsToCheck, {x = self:upperRight().x + 1, y = PixelToAddY})
        PixelToAddY = PixelToAddY + Constants.TILE_SIZE
    end
    table.insert(pixelsToCheck, {x = self:lowerRight().x + 1, y = self:lowerRight().y})

    return #self:getCollidablesFromPoints(pixelsToCheck) > 0
end

function Collidable:getCollidablesFromPoints(pixelsToCheck)
    objects = {}
    for _, checkpoint in pairs(pixelsToCheck) do
        local tile = GlobalState.subLevel:tileFromPoint(checkpoint)
        if tile and tile.solid then
            table.insert(objects, tile)
        else
            for _, blockType in pairs(GlobalState.subLevel["collider-" .. ColliderTypes.BLOCK]) do
                if blockType:pointInside(checkpoint) then
                    table.insert(objects, blockType)
                end
            end
        end
    end
    return objects
end

function Collidable:moveOutsideOf(collidable, direction)
    if self:intersect(collidable) then

        local directionOut -- default (should never be used)

        if direction then
            directionOut = direction
        elseif not ((self.velocity.x == 0) and (self.velocity.y == 0) and (collidable.velocity.x == 0) and (collidable.velocity.y == 0)) then
            directionOut = vectorNormalize(vectorSub(collidable.velocity, self.velocity))
        else
            local center = self:getCenter()
            directionOut = vectorNormalize(vectorSub(center, collidable:getCenter()))
        end

        local multOptions = {
            { axis = 'x', relPos = {x = -1, y = 0} , mult = (collidable.x - self.x - self.width) / directionOut.x }, -- move out to left of collidable
            { axis = 'x', relPos = {x = 1, y = 0} ,mult = (collidable.x + collidable.width - self.x) / directionOut.x }, -- move out to right of collidable
            { axis = 'y', relPos = {x = 0, y = -1} ,mult = (collidable.y - self.y - self.height) / directionOut.y }, -- move out on top of collidable
            { axis = 'y', relPos = {x = 0, y = 1} ,mult = (collidable.y + collidable.height - self.y) / directionOut.y } -- move out on bottom of collidable
        }

        -- also tests if it's infinity, negative infinity, or NaN
        -- then confirms we are not moving into an ajecent tile that's also solid
        local multOptionsGreaterThanZero = table.filter(multOptions, function(k, mult) 
            return (mult.mult ~= nil) and 
                (mult.mult > 0) and 
                (not (mult.mult == math.huge)) and 
                (not (mult.mult == -math.huge)) and 
                (not (mult.mult ~= mult.mult)) and
                (
                    (not collidable.isTile) or
                    (not GlobalState.subLevel:isSolidTileRelative(collidable, mult.relPos))
                )
        end)

        local multiplier = table.min(multOptionsGreaterThanZero, function(mult) 
            return mult.mult
        end)

        if multiplier then
            self[multiplier.axis] = self[multiplier.axis] + (multiplier.mult * directionOut[multiplier.axis])

            if (multiplier.axis == 'x') and self.velocity and self.acceleration then
                self.velocity.x = 0
                self.acceleration.x = 0
                self.lastX = self.x
                return {axis = 'x', direction = {x = directionOut.x, y = 0 }}
            elseif multiplier.axis == 'y' and self.velocity and self.acceleration then
                self.velocity.y = 0
                self.acceleration.y = 0
                self.lastY = self.y
                return {axis ='y', direction = {x = 0, y = directionOut.y }}
            end
        else
            logger("w", "unable to moveOutSideOf in collision case")
        end
    end
    return nil
end

function Collidable:getCollisionCandidates()
    local candidates = {}
    for type, _ in pairs(self.doesCollideWith) do
        for _, collider in pairs(GlobalState.subLevel["collider-" .. type]) do
            -- collider is not this object or one of this objects children
            if (not (collider == self)) and (not (startsWith(collider.id, self.id .. '-'))) then
                table.insert(candidates, collider)
            end
        end
    end
    -- add surrounding blocks
    for indexX = self:lowestIndexX(), self:highestIndexX() do
        for indexY = self:lowestIndexY(), self:highestIndexY() do
            if GlobalState.subLevel.tiles[indexX] and GlobalState.subLevel.tiles[indexX][indexY] then
                table.insert(candidates, GlobalState.subLevel.tiles[indexX][indexY])
            end
        end
    end
    return candidates
end

function Collidable:destroy()
    Renderable.destroy(self)
    self.destroyed = true
    GlobalState.subLevel:destroy(self)
end

function Collidable:render()
    Renderable.render(self)
end

function Collidable:update(dt)
    Renderable.update(self, dt)
end

return Collidable
