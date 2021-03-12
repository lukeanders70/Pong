local TransparentTile = require('src/level/TransparentTile')
local ColliderTypes = require('src/objects/ColliderTypes')

local SpikeTip = Class{__includes = TransparentTile}

function SpikeTip:init(indexX, indexY, id, isSolid)
    TransparentTile.init(self, indexX, indexY, id, isSolid)
    self.solid = false
end

return SpikeTip