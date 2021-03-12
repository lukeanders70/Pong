local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')
local Animation = require('src/textures/Animation')

local TransparentTile = Class{__includes = Tile}

function TransparentTile:init(indexX, indexY, id, isSolid, level)
    Tile.init(self, indexX, indexY, id, isSolid)

    if GlobalState.subLevel.metaData.replaceTexture then
        local replaceID = tonumber(Tile.removeZeroPrefix(GlobalState.subLevel.metaData.replaceTexture))
        self.replaceTexture = TileTextureIndex.fromId(replaceID)
    end
end

function TransparentTile:render()
    if self.replaceTexture then
        GlobalState.camera:draw(self.replaceTexture.texture, self.replaceTexture.quad, self.x, self.y)
    end
    Tile.render(self)
end

return TransparentTile