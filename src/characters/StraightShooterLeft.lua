local TurretType = require('src/characters/TurretType')

local StraightShooterLeft = Class{__includes = TurretType}

StraightShooterLeft.NUM_BOUNCES = 0
function StraightShooterLeft:init(indexX, indexY)
    TurretType.init(self, indexX, indexY, 16, 16, {fireDirection = {x = -1, y = 0}})
end

return StraightShooterLeft