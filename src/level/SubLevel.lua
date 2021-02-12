local TileIndex = require('src/level/TileIndex')
local Player = require('src/characters/Player')
local EnemyMap = require('src/characters/EnemyMap')
local GameObjectMap = require('src/objects/gameObjects/GameObjectsMap')
local Image = require('src/textures/Image')
local Midground = require('src/objects/Midground')
local ColliderTypes = require('src/objects/ColliderTypes')

local SubLevel = Class{}

SubLevel.defaultMetaData = {name="Default Level", playerStart={x = 0, y = 1}}
SubLevel.enemyClassCache = {}
SubLevel.gameObjectClassCache = {}
SubLevel.levelCompleteWait = 2 -- seconds
SubLevel.levelCompleteMotionSlowMultipler = 0.25
function SubLevel:init(worldName, level, subLevelId)
    GlobalState.subLevel = self

    self.updateables = {}
    self.renderables = {}
    for _, v in pairs(ColliderTypes) do
        self["collider-"..v] = {}
    end

    self.level = level
    self.worldName = worldName
    self.id = subLevelId
    self.metaData = SubLevel.safeLoadMetaData(worldName, self.level.id, self.id)

    local SubLevelData = SubLevel.safeLoadData(worldName, self.level.id, self.id, self.metaData.segmentLength or 26, self.metaData.segmentHeight or 10)

    self.tiles = SubLevelData.tiles
    self:addObjects(SubLevelData.objects)
    
    SubLevel.enemyClassCache = {}

    -- images
    self.heartImage = Image.createFromName("heart")
    self.background = Image.createFromName(self.metaData.background)
    self.midgrounds = {}
    for _, midgroundData in pairs(self.metaData.midgrounds) do
        table.insert(self.midgrounds, Midground(Image.createFromName(midgroundData.name), midgroundData.paralaxDivider))
    end

    -- useful values
    self.yMax = #self.tiles[1] * Constants.TILE_SIZE
    self.xMax = #self.tiles * Constants.TILE_SIZE
    self.segmentHeight = self.metaData.segmentHeight or 10

end

function SubLevel:placePlayer()
    self.level.player:setPos(self.metaData.playerStart.x, self.metaData.playerStart.y)
    self:addObject(self.level.player)
end

function SubLevel:addObjects(objects)
    if objects then
        for _, object in pairs(objects) do
            self:addObject(object)
        end
    end
end

function SubLevel:destroy(object)
    local objectID = object.id
    if object.id then
        self.updateables[objectID] = nil
        self.renderables[objectID] = nil
        if object.colliderType and self["collider-" .. object.colliderType] then
            self["collider-"..object.colliderType][objectID] = nil
        end
    else
        logger('e', "no object Id available for object: " ..tostring(object))
    end
end

function SubLevel:addObject(object)
    local id = object.id
    if not id then
        logger('e', 'object was added without id: ' .. tostring(object))
    else
        self.renderables[id] = object
        self.updateables[id] = object
        self:addCollidable(object)
    end
end

function SubLevel:addCollidable(collidable)
    local id = collidable.id
    if collidable.id then
        if collidable.colliderType and self["collider-" .. collidable.colliderType] then
            self["collider-"..collidable.colliderType][id] = collidable
        end
    end
end

function SubLevel.safeLoadMetaData(worldName, levelId, subLevelId)
    local path = "data/worlds/" .. worldName .. "/levels/" .. levelId .. "/" .. subLevelId .. "/" .. "metadata.lua"
    local ok, chunk = pcall( love.filesystem.load, path )
    if not ok then
        logger('e', "failed to find sublevel at path: " .. path .. ": " .. tostring(path))
        return SubLevel.defaultMetaData
    end

    local ok, result = pcall(chunk) -- execute the chunk safely
    if not ok then -- will be false if there is an error
        logger('e', "failed to load sublevel at path: " .. path ..": " .. tostring(result))
        return SubLevel.defaultMetaData
    end

    return result
end

function SubLevel.safeLoadData(worldName, levelId, subLevelId, segmentLength, segmentHeight)
    local path = "data/worlds/" .. worldName .. "/levels/" .. levelId .. "/" .. subLevelId .. "/" .. "level.txt"
    local tiles = {}
    local objects = {}

    local segment = 0
    local indexX = 1
    local indexY = 1
    for line in love.filesystem.lines(path) do
        if line == "" then
            segment = segment + 1
        else
            for tileData in string.gmatch(line, "[^ ]+") do
                local tileIndex = {x = indexX + (segment * segmentLength), y = indexY - (segment * segmentHeight)}
                local newTile = SubLevel.parseTileFromData(tileData, tileIndex.x, tileIndex.y)

                if not tiles[tileIndex.x] then
                    tiles[tileIndex.x] = {}
                end
                tiles[tileIndex.x][tileIndex.y] = newTile.tile
                if newTile.object then
                    table.insert(objects, newTile.object)
                end

                indexX = indexX + 1
            end
            indexX = 1
            indexY = indexY + 1
        end
    end
    return { tiles = tiles, objects = objects }
end

function SubLevel.parseTileFromData(tileData, indexX, indexY)
    local isBlock = tileData:sub(1,1) == "0"
    local isEnemy = tileData:sub(1,1) == "1"
    local isGameObject = tileData:sub(1,1) == "2"

    local isSolid = tileData:sub(2,2) == "1"

    local id = tostring(tileData:sub(3,3)) .. tostring(tileData:sub(4,4))

    if isBlock then
        local tile = TileIndex.create(indexX, indexY, id, isSolid)
        return { tile = tile }
    elseif isEnemy then
        local returnObj = {}
        -- sky block behind enemy
        returnObj.tile = TileIndex.create(indexX, indexY, '00', isSolid)
        local enemyName = getOrElse(EnemyMap, id, nil, "Enemey ID: " .. id .. " not found")
        if enemyName and table.hasKey(SubLevel.enemyClassCache, enemyName) then
            returnObj.object = SubLevel.enemyClassCache[enemyName](indexX, indexY)
        else
            local enemyClass = EnemyMap.loadClassFromName(enemyName)
            SubLevel.enemyClassCache[enemyName] = enemyClass
            returnObj.object = enemyClass(indexX, indexY)
        end
        return returnObj
    elseif isGameObject then
        local returnObj = {}
        -- sky block behind gameObject
        returnObj.tile = TileIndex.create(indexX, indexY, '00', isSolid)
        local gameObjectName = getOrElse(GameObjectMap, id, nil, "Game Object ID: " .. id .. " not found")
        if gameObjectName and table.hasKey(SubLevel.gameObjectClassCache, gameObjectName) then
            returnObj.object = SubLevel.gameObjectClassCache[gameObjectName](indexX, indexY)
        else
            local gameObjectClass = GameObjectMap.loadClassFromName(gameObjectName)
            SubLevel.gameObjectClassCache[gameObjectName] = gameObjectName
            returnObj.object = gameObjectClass(indexX, indexY)
        end
        return returnObj
    else
         --TODO: handle other cases
        return
    end
end

function SubLevel:tileFromPoint(point)
    local indexX = math.floor(point.x / Constants.TILE_SIZE) + 1
    local indexY = math.floor(point.y / Constants.TILE_SIZE) + 1

    if self.tiles[indexX] and self.tiles[indexX][indexY] then
        return self.tiles[indexX][indexY]
    else
        return nil
    end
end

function SubLevel:update(dt)
    for indexX = self:minVisbileIndexX(), self:maxVisibleIndexX() do
        for indexY = self:minVisbileIndexY(), self:maxVisibleIndexY() do
            if self.tiles[indexX][indexY].isUpdateable then
                self.tiles[indexX][indexY]:update(dt)
            end
        end
    end
    for _, updateable in pairs(self.updateables) do
        if self:renderableInFrame(updateable) then
            updateable:update(dt)
        elseif updateable.offscreenUpdate then
            updateable:offscreenUpdate(dt)
        end
    end
    for _, v in pairs(ColliderTypes) do
        for _, collidable in pairs(self["collider-"..v]) do
            collidable:updateCollisions(dt)
        end
    end
end

function SubLevel:minVisbileIndexX()
    return math.floor(math.max((-GlobalState.camera.x_offest / Constants.TILE_SIZE) -1, 1))
end

function SubLevel:maxVisibleIndexX()
    return math.ceil(math.min(((-GlobalState.camera.x_offest + Constants.VIRTUAL_WIDTH) / Constants.TILE_SIZE) + 1, #self.tiles))
end

function SubLevel:minVisbileIndexY()
    return math.floor(math.max((-GlobalState.camera.y_offset / Constants.TILE_SIZE) -1, 1))
end

function SubLevel:maxVisibleIndexY()
    return math.ceil(math.min(((-GlobalState.camera.y_offset + Constants.VIRTUAL_HEIGHT) / Constants.TILE_SIZE) + 1, self.segmentHeight))
end

function SubLevel:renderableInFrame(renderable)
   return (
        (renderable:upperLeft().x <= Constants.VIRTUAL_WIDTH - GlobalState.camera.x_offest) and
        (renderable:lowerRight().x >= -GlobalState.camera.x_offest) and
        (renderable:upperLeft().y <= Constants.VIRTUAL_HEIGHT - GlobalState.camera.y_offset) and
        (renderable:lowerRight().y >= -GlobalState.camera.y_offset)
    )
end

function SubLevel:renderHearts()
    local x = 5
    local y = 5
    for i = 1, self.level.player.health do 
        love.graphics.drawScaled( self.heartImage.texture, self.heartImage.quad, x, y)
        x = x + 25
    end
end

function SubLevel:renderBackground()
    
    if self.background then
        love.graphics.drawScaledNoQuad(self.background.texture, 0, 0)
    end
    for _, midground in pairs(self.midgrounds) do
        midground:render()
    end
end

function SubLevel:render()
    self:renderBackground()
    for indexX = self:minVisbileIndexX(), self:maxVisibleIndexX() do
        for indexY = self:minVisbileIndexY(), self:maxVisibleIndexY() do
            if self.tiles[indexX][indexY].isRenderable then
                self.tiles[indexX][indexY]:render()
            end
        end
    end
    for id, renderable in pairs(self.renderables) do
        if self:renderableInFrame(renderable) and (not (id == "player")) then     
            renderable:render()
        end
    end
    self.renderables["player"]:render()
    self:renderHearts()
end

return SubLevel