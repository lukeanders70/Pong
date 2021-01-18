local Node = require('src/world/Node')
local Path = require('src/world/Path')

local CornerNode = Class{__includes = Node}

function CornerNode:init(x, y, neighbors)
    Node.init(self, x, y, neighbors)
end

return CornerNode