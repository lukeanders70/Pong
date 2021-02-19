local PacerType = require('src/characters/PacerType')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local CeilingCrawler = Class{__includes = PacerType}

function CeilingCrawler:init(indexX, indexY, options)
    local width = 21
    local height = 12
    
    PacerType.init(self, indexX, indexY, width, height, {0, 0, 0, 255}, { gravity = false })
    self.fallOffEdges = false
    self.ceilingCrawl = true

    self.image = ObjectTextureIndex.getAnimation('crawler', self.width, self.height, self.timerGroup)
    self.image:continousCycling()

    self:flipVertical()
end

function CeilingCrawler:update(dt)
    PacerType.update(self, dt)
end

return CeilingCrawler