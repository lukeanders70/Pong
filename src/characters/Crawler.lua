local PacerType = require('src/characters/PacerType')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Crawler = Class{__includes = PacerType}

function Crawler:init(indexX, indexY, options)
    local width = 21
    local height = 12
    
    PacerType.init(self, indexX, indexY, width, height, {0, 0, 0, 255}, { gravity = true })

    self.image = ObjectTextureIndex.getAnimation('crawler', self.width, self.height, self.timerGroup)
    self.image:continousCycling()

    self.noFriction = true

    self.directionMultiplier = 1
    self.velocity.x = PacerType.MOVEMENT_SPEED * self.directionMultiplier
end

function Crawler:update(dt)
    PacerType.update(self, dt)
end

return Crawler