local Tiles = require('src/level/Tiles')
local TileMap = require('src/level/TileMap')
local Player = require('src/characters/Player')

local Level = Class{}

Level.defaultMetaData = {name="Default Level", playerStart={x = 0, y = 1}}

function Level:init(id)
    local path = "data/levels/" .. id .. "/"
    self.metaData = Level.safeLoadMetaData(path .. "metadata.lua")
    self.tiles = Level.parseFromPath(path .. "level.txt")
    self.updateables = {}
    self.renderables = {}
    self.collidables = {}

    self.player = Player(self.metaData.playerStart.x, self.metaData.playerStart.y)

    table.insert(self.updateables, self.player)
    table.insert(self.renderables, self.player)
    table.insert(self.collidables, self.player)
end

function Level.safeLoadMetaData(path)
    local ok, chunk = pcall( love.filesystem.load, path )
    if not ok then
        logger('e', "failed to find level at path: " .. path .. ": " .. tostring(chunk))
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

    local indexX = 1
    local indexY = 1
    for line in love.filesystem.lines(path) do
        for tileData in string.gmatch(line, "[^ ]+") do
            local newTile = Level.parseTileFromData(tileData, indexX, indexY)

            if not tiles[indexX] then
                tiles[indexX] = {}
            end
            tiles[indexX][indexY] = newTile

            indexX = indexX + 1
        end
        indexX = 1
        indexY = indexY + 1
    end
    return tiles
end

function Level.parseTileFromData(tileData, indexX, indexY)
    local isBlock = tileData:sub(1,1) == "0"
    local isEnemy = not isBlock

    local isSolid = tileData:sub(2,2) == "1"

    local id = tostring(tileData:sub(3,3)) .. tostring(tileData:sub(4,4))

    if isBlock then
        tileName = getOrElse(TileMap, id, "sky", "Tile ID " .. id .. " not found, defaulting to sky")
        tileClass = replaceIfNil(Tiles[tileName:gsub("^%l", string.upper)], Tiles[1])
        tile = tileClass(indexX, indexY, isSolid)
        return tile
    elseif isEnemy then
         --TODO: handle case where isEnemy
        return
    else
         --TODO: handle case where isEnemy
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