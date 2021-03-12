local TransparentTile = require('src/level/TransparentTile')
local ColliderTypes = require('src/objects/ColliderTypes')

local Spike = Class{__includes = TransparentTile}

function Spike:init(indexX, indexY, id, isSolid)
    TransparentTile.init(self, indexX, indexY, id, isSolid)
    self.isSolid = false
end

function Spike:collide(collidable, dt)
    if (collidable.id == "player") then
        collidable:characterCollide(self, dt)
    elseif (collidable.colliderType == ColliderTypes.CHARACTER) then
        collidable:destroy()
    else
        TransparentTile.collide(self, collidable, dt)
    end
end

function Spike:steppedOn(character, dt)
    self:collide(character, dt)
    if character.velocity.y == 0 then
        character.velocity.y = -50
    end
end

return Spike