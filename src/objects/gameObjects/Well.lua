local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local basicTextureIndex = require('src/textures/BasicTexturesIndex')
local Image = require('src/textures/Image')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Well = Class{__includes = Collidable}

function Well:init(indexX, indexY)
    Collidable.init(self,
    {
        x = (indexX - 1) * Constants.TILE_SIZE,
        y = (indexY -1) * Constants.TILE_SIZE,
        width = 48,
        height = 32
    })
    self.yRenderOffset = -16
    self.colliderType = ColliderTypes.BLOCK
    self.id = tostring(tostring(self.x) .. "|" .. tostring(self.y))
    self.image = ObjectTextureIndex.getImage('well', self.width, self.height - (self.yRenderOffset))
end

return Well