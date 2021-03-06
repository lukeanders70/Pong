local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local basicTextureIndex = require('src/textures/BasicTexturesIndex')
local Image = require('src/textures/Image')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Door = Class{__includes = Collidable}

function  Door:init(indexX, indexY)
    Collidable.init(self,
    {
        x = (indexX - 1) * Constants.TILE_SIZE,
        y = (indexY -1) * Constants.TILE_SIZE,
        width = 32,
        height = 64
    })
    self.colliderType = ColliderTypes.INTERACT
    self.doesCollideWith = {
        [ColliderTypes.CHARACTER] = true
    }

    self.id = tostring(tostring(self.x) .. "|" .. tostring(self.y))
    self.staticImage = ObjectTextureIndex.getImage('door', self.width, self.height)
    self.openAnimation = ObjectTextureIndex.getAnimation('door', self.width, self.height, self.timerGroup)
    self.image = self.staticImage

    self.alreadyRemoved = false
end

function  Door:render(dt)
    Collidable.render(self, dt)
end

return  Door