local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')
local ColliderTypes = require('src/objects/ColliderTypes')

local BubblingTar = Class{__includes = Tile}

function BubblingTar:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isUpdateable = true
    self.images = TileTextureIndex.animationFromId(self.id, 3)
end

function BubblingTar:update()
    self.image = self.images[(GlobalState.timerValue % 3) + 1]
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
    [30] = BubblingTar,
    [29] = Tar
}