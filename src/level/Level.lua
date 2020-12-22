local Tiles = require('src/level/Tiles')
local TileMap = require('src/level/TileMap')
local Player = require('src/characters/Player')
local EnemyMap = require('src/characters/EnemyMap')

local Level = Class{}

Level.defaultMetaData = {name="Default Level", playerStart={x = 0, y = 1}}
Level.enemyClassCache = {}
function Level:init(id)
    self.updateables = {}
    self.renderables = {}
    self.collidables = {}
    self.enemies = {}

    local path = "data/levels/" .. id .. "/"
    self.metaData = Level.safeLoadMetaData(path .. "metadata.lua")
    local levelData = Level.parseFromPath(path .. "level.txt")

    self.tiles = levelData.tiles
    self:addEnemies(levelData.enemies)
    
    Level.enemyClassCache = {}

    self.player = Player(self.metaData.playerStart.x, self.metaData.playerStart.y)

    table.insert(self.updateables, self.player)
    table.insert(self.renderables, self.player)
    table.insert(self.collidables, self.player)
end

function Level:addEnemies(enemies)
    if enemies then
        for _, enemy in pairs(enemies) do
            self:addEnemy(enemy)
        end
    end
end

function Level:addEnemy(enemy)
    table.insert(self.enemies, enemy)
    table.insert(self.updateables, enemy)
    table.insert(self.renderables, enemy)
    table.insert(self.collidables, enemy)
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
        updateable:update(self, dt)
    end
end

function Level:render()
    for indexX = 1, #self.tiles do
        for indexY = 1, #self.tiles[indexX] do
            self.tiles[indexX][indexY]:render()
        end
    end
    for _, renderable in pairs(self.renderables) do
        renderable:render()
    end
end

return Level