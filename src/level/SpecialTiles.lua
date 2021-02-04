local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')
local ColliderTypes = require('src/objects/ColliderTypes')

local BubblingTar = Class{__includes = Tile}

function BubblingTar:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isUpdateable = true
    self.numFrames = 7
    self.offFrames = 10
    self.randomFrameOffset = love.math.random(self.numFrames + self.offFrames)
    self.images = TileTextureIndex.animationFromId(self.id, self.numFrames)
end

function BubblingTar:update()
    local imageIndex = math.max(((GlobalState.timerValue + self.randomFrameOffset) % (self.numFrames + self.offFrames)) - self.offFrames, 0) + 1
    self.image = self.images[imageIndex]
    if self.image == nil then
        print(imageIndex)
    end
end


local Tar = Class{__includes = Tile}

function Tar:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        collidable:destroy(collidable, dt)
    end
end

local Sky = Class{__includes = Tile}

function Sky:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isRendeable = false
    self.color = {0, 0, 0, 0}
end

return {
    [0] = Sky,
    [29] = BubblingTar,
    [28] = Tar
}