local TurretType = require('src/characters/TurretType')

local StraightShooterRight = Class{__includes = TurretType}

StraightShooterRight.NUM_BOUNCES = 0
function StraightShooterRight:init(indexX, indexY)
    TurretType.init(self, indexX, indexY, 16, 16, {fireDirection = {x = 1, y = 0}})
end

return StraightShooterRight