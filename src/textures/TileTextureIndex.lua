local Image = require('src/textures/Image')

local TileTextureIndex = {}

TileTextureIndex.tileTextureImageCache = {}
TileTextureIndex.texture = love.graphics.newImage('assets/tiles-small.png')
TileTextureIndex.numColumns = 8
function TileTextureIndex.fromId(id)
    if (type(id) ~= 'number') or (id <= 0) then
        logger('w', 'attempted to retreive TileTexture with invalid id: ' .. tostring(id))
        return nil
    end
    local zeroIndexId = id - 1
    if TileTextureIndex.tileTextureImageCache[zeroIndexId] then
        return TileTextureIndex.tileTextureImageCache[zeroIndexId]
    else
        local indicies = TileTextureIndex.IndiciesFromId(zeroIndexId)
        local quad = love.graphics.newQuad(
            indicies.indexX * Constants.TILE_SIZE,
            indicies.indexY * Constants.TILE_SIZE,
            Constants.TILE_SIZE,
            Constants.TILE_SIZE,
            TileTextureIndex.texture:getDimensions()
        )
        local image = Image(TileTextureIndex.texture, quad)
        TileTextureIndex.tileTextureImageCache[zeroIndexId] = image
        return image
    end
end

function TileTextureIndex.animationFromId(id, numFrames)
    local idToGrab = id
    local images = {}
    while idToGrab < id + numFrames do
        table.insert(images, TileTextureIndex.fromId(idToGrab))
        idToGrab = idToGrab + 1
    end
    return images
end

function TileTextureIndex.IndiciesFromId(id)
    return { indexX = id % TileTextureIndex.numColumns, indexY = math.floor(id / TileTextureIndex.numColumns)}
end

return TileTextureIndex