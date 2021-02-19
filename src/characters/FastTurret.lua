local Turret = require('src/characters/Turret')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local FastTurret = Class{__includes = Turret}

FastTurret.NUM_BOUNCES = 0
FastTurret.FIRE_RATE = 1
function FastTurret:init(indexX, indexY)
    Turret.init(self, indexX, indexY)
    self.image = ObjectTextureIndex.getAnimation('fast-turret', self.width, self.height, self.timerGroup)
    self.image:continousCycling()
end

return FastTurret