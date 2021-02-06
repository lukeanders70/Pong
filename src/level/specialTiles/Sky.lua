local Tile = require('src/level/Tiles')

local Sky = Class{__includes = Tile}

function Sky:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isRendeable = false
    self.color = {0, 0, 0, 0}
end

return Sky