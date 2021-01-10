local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')
local TileTextureIndex = require('src/textures/TileTextureIndex')

local TileBase = Class{__includes = Collidable}

TileBase.color = {0, 0, 0, 255}
function TileBase:init(indexX, indexY, isSolid)
    Collidable.init(self, 
    {
        x = Constants.TILE_SIZE * (indexX - 1),
        y = Constants.TILE_SIZE * (indexY - 1),
        width = Constants.TILE_SIZE,
        height = Constants.TILE_SIZE
    })
    self.solid = isSolid
    self.indexX = indexX
    self.indexY = indexY
end

local Tiles = {
    Sky = Class{__includes = TileBase,
        color = {0, 0, 0, 0},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY, isSolid)
            self.image = nil
            self.isSky = true -- special case so render knows to just skip this one
        end
    },
    Dirt = Class{__includes = TileBase,
        color = {200, 200, 200, 255},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY, isSolid)
            self.image = TileTextureIndex.fromId(1)
        end
    },
    FossilDirt = Class{__includes = TileBase,
        color = {200, 200, 200, 255},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY, isSolid)
            self.image = TileTextureIndex.fromId(2)
        end
    },
    Grass = Class{__includes = TileBase,
        color = {200, 200, 200, 255},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY, isSolid)
            self.image = TileTextureIndex.fromId(3)
        end
    }
}   

return Tiles