local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local basicTextureIndex = require('src/textures/BasicTexturesIndex')
local Image = require('src/textures/Image')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Bell = Class{__includes = Collidable}

function Bell:init(indexX, indexY)
    Collidable.init(self,
    {
        x = (indexX - 1) * Constants.TILE_SIZE,
        y = (indexY -1) * Constants.TILE_SIZE,
        width = 64,
        height = 64
    })
    self.colliderType = ColliderTypes.INTERACT
    self.id = tostring(tostring(self.x) .. "|" .. tostring(self.y))
    self.image = ObjectTextureIndex.getAnimation('bell-idle', self.width, self.height, self.timerGroup)
    self.image:continousCycling()

    self.alreadyRemoved = false
end

function Bell:collide(collidable)
    if (collidable.colliderType == ColliderTypes.CHARACTER) and (collidable.id == "player") and (not self.alreadyRemoved) then
        GlobalState.level:levelComplete()
        self.alreadyRemoved = true
    end
end

function Bell:render(dt)
    Collidable.render(self, dt)
end

return Bell