local SpecialTilesIndex = require('src/level/specialTiles/SpecialTilesIndex')
local Tile = require('src/level/Tiles')

local TileIndex = {}

function TileIndex.create(indexX, indexY, id, isSolid)
    local realId = tonumber(Tile.removeZeroPrefix(id))
    if realId and SpecialTilesIndex[realId] then
        return SpecialTilesIndex[realId](indexX, indexY, id, isSolid)
    else
        return Tile(indexX, indexY, id, isSolid)
    end
end

return TileIndex