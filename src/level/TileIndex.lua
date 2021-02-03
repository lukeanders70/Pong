local SpecialTiles = require('src/level/SpecialTiles')
local Tile = require('src/level/Tiles')

local TileIndex = {}

function TileIndex.create(indexX, indexY, id, isSolid)
    local realId = tonumber(Tile.removeZeroPrefix(id))
    if realId and SpecialTiles[realId] then
        return SpecialTiles[realId](indexX, indexY, id, isSolid)
    else
        return Tile(indexX, indexY, id, isSolid)
    end
end

return TileIndex