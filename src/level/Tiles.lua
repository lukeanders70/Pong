local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local TileTextureIndex = require('src/textures/TileTextureIndex')

local Tile = Class{__includes = Collidable}

Tile.color = {0, 0, 0, 255}
function Tile:init(indexX, indexY, id, isSolid)
    Collidable.init(self, 
    {
        x = Constants.TILE_SIZE * (indexX - 1),
        y = Constants.TILE_SIZE * (indexY - 1),
        width = Constants.TILE_SIZE,
        height = Constants.TILE_SIZE
    })
    self.solid = isSolid
    self.indexX = indexX
    self.indexY = indexY

    self.id = tonumber(Tile.removeZeroPrefix(id))

    self.isUpdateable = false
    self.isRenderable = true

    if self.id > 0 then
        self.image = TileTextureIndex.fromId(self.id)
    end

end

function Tile.removeZeroPrefix(index)
    if startsWith(index, '0') then
        local sub = string.sub(index, 2, 2)
        return sub
    else
        return index
    end
end

return Tile