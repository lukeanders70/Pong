local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Well = Class{__includes = Collidable}

function Well:init(indexX, indexY, parameters)
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

    if parameters then
        self.transportSubLevelId = parameters.subLevelId
        self.transportPosition = parameters.playerPosition
    end
    self.alreadyPresssed = false
end

function Well:downTrigger()
    if self.transportSubLevelId and (not self.alreadyPresssed) then
        self.alreadyPresssed = true
        GlobalState.level:swapSubLevel(self.transportSubLevelId, self.transportPosition)
    end
end

return Well