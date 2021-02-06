local Tile = require('src/level/Tiles')

local Tar = Class{__includes = Tile}

function Tar:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        collidable:destroy(collidable, dt)
    end
end

return Tar