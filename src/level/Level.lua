local Tiles = require('src/level/Tiles')
local TileMap = require('src/level/TileMap')
local Player = require('src/characters/Player')
local Bell = require('src/objects/Bell')
local EnemyMap = require('src/characters/EnemyMap')
local Image = require('src/textures/Image')
local Midground = require('src/objects/Midground')

local Level = Class{}

Level.defaultMetaData = {name="Default Level", playerStart={x = 0, y = 1}}
Level.enemyClassCache = {}
Level.levelCompleteWait = 2 -- seconds
Level.levelCompleteMotionSlowMultipler = 0.25
function Level:init(id)
    GlobalState.level = self

    self.updateables = {}
    self.renderables = {}
    self.collidables = {}
    self.priorityCollidables = {}
    self.enemies = {}
    self.balls = {}

    local path = "data/levels/" .. id .. "/"
    self.metaData = Level.safeLoadMetaData(path .. "metadata.lua")
    local levelData = Level.parseFromPath(path .. "level.txt")

    self.tiles = levelData.tiles
    self:addEnemies(levelData.enemies)
    
    Level.enemyClassCache = {}

    self.player = Player(self.metaData.playerStart.x, self.metaData.playerStart.y)
    self.bell = Bell(self.metaData.endBell.x, self.metaData.endBell.y)

    assert(self.player.id, "Player obejct must have hash id defined")
    self.updateables[self.player.id] = self.player
    self.renderables[self.player.id] = self.player
    self.collidables[self.player.id] = self.player

    self.renderables[self.bell.id] = self.bell
    self.collidables[self.bell.id] = self.bell

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

    self.levelCompleted = false
end

function Level:levelComplete()
    if not self.levelCompleted then
        Timer.after(self.levelCompleteWait, function()
            GlobalState.stateMachine:remove()
        end)
    end
    self.levelCompleted = true
end

function Level:addEnemies(enemies)
    if enemies then
        for _, enemy in pairs(enemies) do
            self:addEnemy(enemy)
        end
    end
end

function Level:destroy(object)
    local objectID = object.id
    if object.id then
        self.enemies[objectID] = nil
        self.balls[objectID] = nil
        self.updateables[objectID] = nil
        self.renderables[objectID] = nil
        self.collidables[objectID] = nil
        self.priorityCollidables[objectID] = nil
    else
        logger('e', "no object Id available for object: " ..tostring(object))
    end
end

function Level:addEnemy(enemy)
    local enemyId = enemy.id
    if not enemy.id then
        logger('e', "no enemy Id available for enemy: " ..tostring(enemy))
    else
        self.enemies[enemyId] = enemy
        self:addObject(enemy, enemyId)
    end
end

function Level:addBall(ball)
    local ballId = ball.id
    if not ball.id then
        logger('e', "no ball ID available for ball: " .. tostring(ball))
    else
        self.balls[ballId] = ball
        self:addObject(ball, ballId)
    end
end

function Level:addObject(object, id)
    self.updateables[id] = object
    self.renderables[id] = object
    self.collidables[id] = object
end

function Level.safeLoadMetaData(path)
    local ok, chunk = pcall( love.filesystem.load, path )
    if not ok then
        logger('e', "failed to find level at path: " .. path .. ": " .. tostring(path))
        return Level.defaultMetaData
    end

    local ok, result = pcall(chunk) -- execute the chunk safely
    if not ok then -- will be false if there is an error
        logger('e', "failed to load level at path: " .. path ..": " .. tostring(result))
        return Level.defaultMetaData
    end

    return result
end

function Level.parseFromPath(path)
    local tiles = {}
    local enemies = {}

    local indexX = 1
    local indexY = 1
    for line in love.filesystem.lines(path) do
        for tileData in string.gmatch(line, "[^ ]+") do
            local newTile = Level.parseTileFromData(tileData, indexX, indexY)

            if not tiles[indexX] then
                tiles[indexX] = {}
            end
            tiles[indexX][indexY] = newTile.tile
            if newTile.enemy then
                table.insert(enemies, newTile.enemy)
            end

            indexX = indexX + 1
        end
        indexX = 1
        indexY = indexY + 1
    end
    return { tiles = tiles, enemies = enemies }
end

function Level.parseTileFromData(tileData, indexX, indexY)
    local isBlock = tileData:sub(1,1) == "0"
    local isEnemy = not isBlock

    local isSolid = tileData:sub(2,2) == "1"

    local id = tostring(tileData:sub(3,3)) .. tostring(tileData:sub(4,4))

    if isBlock then
        local tileName = getOrElse(TileMap, id, "sky", "Tile ID " .. id .. " not found, defaulting to sky")
        local tileClass = replaceIfNil(Tiles[tileName:gsub("^%l", string.upper)], Tiles["Sky"])
        local tile = tileClass(indexX, indexY, isSolid)
        return { tile = tile }
    elseif isEnemy then
        local returnObj = {}
        -- sky block behind enemy
        returnObj.tile = Tiles["Sky"](indexX, indexY, false)
        local enemyName = getOrElse(EnemyMap, id, nil, "Enemey ID: " .. id .. " not found")
        if enemyName and table.hasKey(Level.enemyClassCache, enemyName) then
            returnObj.enemy = enemyClassCache[enemyName](indexX, indexY)
        else
            local enemyClass = EnemyMap.loadClassFromName(enemyName)
            Level.enemyClassCache[enemyName] = enemyClass
            returnObj.enemy = enemyClass(indexX, indexY)
        end
        return returnObj
    else
         --TODO: handle other cases
        return
    end
end

function Level:tileFromPoint(point)
    local indexX = math.floor(point.x / Constants.TILE_SIZE) + 1
    local indexY = math.floor(point.y / Constants.TILE_SIZE) + 1

    if self.tiles[indexX] and self.tiles[indexX][indexY] then
        return self.tiles[indexX][indexY]
    else
        return nil
    end
end

function Level:update(dt)
    for _, updateable in pairs(self.updateables) do
        if self.levelCompleted then
            self.player:update(dt * self.levelCompleteMotionSlowMultipler)
        else
            if self:renderableInFrame(updateable) then
                updateable:update(dt)
            elseif updateable.offscreenUpdate then
                updateable:offscreenUpdate(dt)
            end
        end
    end
    for _, collidable in pairs(self.collidables) do
        if self:renderableInFrame(collidable) then
            collidable:updateCollisions(dt)
        end
    end
end

function Level:minVisbileIndexX()
    return math.floor(math.max((-GlobalState.camera.x_offest / Constants.TILE_SIZE) -1, 1))
end

function Level:maxVisibleIndexX()
    return math.ceil(math.min(((-GlobalState.camera.x_offest + Constants.VIRTUAL_WIDTH) / Constants.TILE_SIZE) + 1, #self.tiles))
end

function Level:minVisbileIndexY()
    return math.floor(math.max((-GlobalState.camera.y_offset / Constants.TILE_SIZE) -1, 1))
end

function Level:maxVisibleIndexY()
    return math.ceil(math.min(((-GlobalState.camera.y_offset + Constants.VIRTUAL_HEIGHT) / Constants.TILE_SIZE) + 1, #self.tiles[1]))
end

function Level:renderableInFrame(renderable)
   return (
        (renderable:upperLeft().x <= Constants.VIRTUAL_WIDTH - GlobalState.camera.x_offest) and
        (renderable:lowerRight().x >= -GlobalState.camera.x_offest) and
        (renderable:upperLeft().y <= Constants.VIRTUAL_HEIGHT - GlobalState.camera.y_offset) and
        (renderable:lowerRight().y >= -GlobalState.camera.y_offset)
    )
end

function Level:renderHearts()
    local x = 5
    local y = 5
    for i = 1, self.player.health do 
        love.graphics.draw( self.heartImage.texture, self.heartImage.quad, x, y)
        x = x + 25
    end
end

function Level:renderBackground()
    
    if self.background then
        love.graphics.draw(self.background.texture, 0, 0)
    end
    for _, midground in pairs(self.midgrounds) do
        midground:render()
    end
end

function Level:render()
    self:renderBackground()
    for indexX = self:minVisbileIndexX(), self:maxVisibleIndexX() do
        for indexY = self:minVisbileIndexY(), self:maxVisibleIndexY() do
            if not self.tiles[indexX][indexY].isSky then
                self.tiles[indexX][indexY]:render()
            end
        end
    end
    for _, renderable in pairs(self.renderables) do
        if self:renderableInFrame(renderable) then
            renderable:render()
        end
    end
    self:renderHearts()
end

return Level