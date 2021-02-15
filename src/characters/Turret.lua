local TurretType = require('src/characters/TurretType')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Turret = Class{__includes = TurretType}

function Turret:init(indexX, indexY)
    TurretType.init(self, indexX, indexY)
    self.width = 32
    self.height = 32
    self.image = ObjectTextureIndex.getAnimation('turret', self.width, self.height, self.timerGroup)
    self.image:continousCycling()
end

return Turret