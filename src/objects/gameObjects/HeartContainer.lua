local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local HeartContainer = Class{__includes = Collidable}

function HeartContainer:init(indexX, indexY, parameters)
    Collidable.init(self,
    {
        x = (indexX - 1) * Constants.TILE_SIZE,
        y = (indexY -1) * Constants.TILE_SIZE,
        width = 19,
        height = 17
    })
    self.yRenderOffset = -16
    self.colliderType = ColliderTypes.INTERACT
    self.id = tostring(tostring(self.x) .. "|" .. tostring(self.y))
    self.image =  ObjectTextureIndex.getAnimation('heart-spin', self.width, self.height, self.timerGroup)
    self.image:continousCycling()
    self.alreadyRemoved = false
end

function HeartContainer:collide(collidable)
    if (collidable.colliderType == ColliderTypes.CHARACTER) and (collidable.id == "player") and (not self.alreadyRemoved) then
        collidable:addHealth()
        GlobalState.subLevel:destroy(self)
        self.alreadyRemoved = true
    end
end

return HeartContainer