local PacerType = require('src/characters/PacerType')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local CrawlerBlue = Class{__includes = PacerType}

function CrawlerBlue:init(indexX, indexY, options)
    local width = 21
    local height = 12
    
    PacerType.init(self, indexX, indexY, width, height, {0, 0, 0, 255}, { gravity = true })
    self.fallOffEdges = true

    self.image = ObjectTextureIndex.getAnimation('crawler-blue', self.width, self.height, self.timerGroup)
    self.image:continousCycling()
end

function CrawlerBlue:update(dt)
    PacerType.update(self, dt)
end

return CrawlerBlue