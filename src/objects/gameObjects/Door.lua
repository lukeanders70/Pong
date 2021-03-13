local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local basicTextureIndex = require('src/textures/BasicTexturesIndex')
local Image = require('src/textures/Image')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Door = Class{__includes = Collidable}

function  Door:init(indexX, indexY, parameters)
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

    if parameters then
        self.transportSubLevelId = parameters.subLevelId
        self.transportPosition = parameters.playerPosition
    end

    self.alreadyPressed = false
end

function Door:collide(collidable)
    if (collidable.colliderType == ColliderTypes.CHARACTER) and (collidable.id == "player") and (not self.alreadyPressed) then
        if love.keyboard.isDown( 's' ) and (self.transportSubLevelId) then
            self.alreadyPressed = true
            self.image = self.openAnimation
            self.image:cycleOnce(function()
                GlobalState.level:swapSubLevel(self.transportSubLevelId, self.transportPosition)
            end)
        end
    end
end

return Door