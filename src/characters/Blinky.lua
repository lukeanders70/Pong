local TurretType = require('src/characters/TurretType')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Blinky = Class{__includes = TurretType}

Blinky.NUM_BOUNCES = 5
Blinky.FIRE_RATE = 3
function Blinky:init(indexX, indexY)
    TurretType.init(self, indexX, indexY)
    self.width = 16
    self.height = 16
    self.static = ObjectTextureIndex.getImage('blinky', self.width, self.height)
    self.blink = ObjectTextureIndex.getAnimation('blinky', self.width, self.height, self.timerGroup)
    self.image = self.static
end

function Blinky:attack()
    self.image = self.blink
    self.image:cycleOnce(function()
        self.image = self.static
        TurretType.attack(self)
    end)
end

return Blinky