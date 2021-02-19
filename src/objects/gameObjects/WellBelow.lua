local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local WellBelow = Class{__includes = Collidable}

function WellBelow:init(indexX, indexY, parameters)
    Collidable.init(self,
    {
        x = (indexX - 1) * Constants.TILE_SIZE,
        y = (indexY -1) * Constants.TILE_SIZE,
        width = 48,
        height = 32
    })
    self.colliderType = ColliderTypes.BLOCK
    self.id = tostring(tostring(self.x) .. "|" .. tostring(self.y))
    self.image = ObjectTextureIndex.getImage('well-below', self.width, self.height)

    if parameters then
        self.transportSubLevelId = parameters.subLevelId
        self.transportPosition = parameters.playerPosition
    end
end

function WellBelow:upTrigger()
    if self.transportSubLevelId then
        GlobalState.level:swapSubLevel(self.transportSubLevelId, self.transportPosition)
    end
end
return WellBelow