local TurretType = require('src/characters/TurretType')
local RusherType = require('src/characters/RusherType')
local Ball = require('src/objects/Ball')
local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')

local Blinky = Class{__includes = {TurretType, RusherType}}

Blinky.NUM_BOUNCES = 5
Blinky.FIRE_RATE = 3
Blinky.MIN_DISTANCE = 6 * Constants.TILE_SIZE
Blinky.DISTANCE_MULTIPLIER = 0.2
function Blinky:init(indexX, indexY)
    self.width = 16
    self.height = 16
    RusherType.init(self, indexX, indexY, self.width, self.height)
    TurretType.init(self, indexX, indexY, self.width, self.height)
    self.static = ObjectTextureIndex.getImage('blinky', self.width, self.height)
    self.blink = ObjectTextureIndex.getAnimation('blinky', self.width, self.height, self.timerGroup)
    self.image = self.static
end

function Blinky:update(dt)
    TurretType.update(self, dt)
    RusherType.update(self, dt)
end

function Blinky:attack()
    self.image = self.blink
    self.image:cycleOnce(function()
        self.image = self.static
        TurretType.attack(self)
    end)
end

return Blinky