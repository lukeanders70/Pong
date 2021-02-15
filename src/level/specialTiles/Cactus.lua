local Tile = require('src/level/Tiles')
local ColliderTypes = require('src/objects/ColliderTypes')

local Cactus = Class{__includes = Tile}

function Cactus:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isSolid = false
end

function Cactus:collide(collidable, dt)
    if (collidable.id == "player") then
        collidable:characterCollide(self, dt)
    elseif (collidable.colliderType == ColliderTypes.CHARACTER) then
        collidable:destroy()
    else
        Tile.collide(self, collidable, dt)
    end
end

function Cactus:steppedOn(character, dt)
    self:collide(character, dt)
    if character.velocity.y == 0 then
        character.velocity.y = -50
    end
end

return Cactus