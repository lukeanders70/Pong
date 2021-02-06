local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')

local BubblingTar = Class{__includes = Tile}

function BubblingTar:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isUpdateable = true
    self.numFrames = 7
    self.offFrames = 20
    self.randomFrameOffset = love.math.random(self.numFrames + self.offFrames)
    self.images = TileTextureIndex.animationFromId(self.id, self.numFrames)
end

function BubblingTar:update()
    local imageIndex = math.max(((GlobalState.timerValue + self.randomFrameOffset) % (self.numFrames + self.offFrames)) - self.offFrames, 0) + 1
    self.image = self.images[imageIndex]
end

return BubblingTar