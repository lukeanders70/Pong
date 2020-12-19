local Collidable = require('src/objects/Collidable')
local ColliderTypes = require('src/objects/ColliderTypes')

local TileBase = Class{__includes = Collidable}

TileBase.color = {0, 0, 0, 255}
function TileBase:init(indexX, indexY)
    Collidable.init(self, 
    {
        x = Constants.TILE_SIZE * (indexX - 1),
        y = Constants.TILE_SIZE * (indexY - 1),
        width = Constants.TILE_SIZE,
        height = Constants.TILE_SIZE
    })
    self.indexX = indexX
    self.indexY = indexY
end

function TileBase:render()
    love.graphics.setColor(unpack(self.color))
    GlobalState.camera:rectangle(
        "fill",
        self.x,
        self.y,
        Constants.TILE_SIZE,
        Constants.TILE_SIZE
    )
    love.graphics.setColor(255,255,255,255)
end

local Tiles = {
    Sky = Class{__includes = TileBase,
        color = {100, 100, 100, 255},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY)
            self.solid = isSolid
        end
    },
    Cubit = Class{__includes = TileBase,
        color = {200, 200, 200, 255},
        init = function(self, indexX, indexY, isSolid)
            TileBase.init(self, indexX, indexY)
            self.solid = isSolid
        end
    }
}   

return Tiles