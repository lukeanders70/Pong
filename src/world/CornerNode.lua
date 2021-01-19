local Node = require('src/world/Node')
local Path = require('src/world/Path')

local CornerNode = Class{__includes = Node}

function CornerNode:init(x, y, neighbors, graph)
    Node.init(self, x, y, neighbors, graph)
end

function CornerNode:setActive()
    self.state = self:setComplete() -- we treat corners as levels that just so happened to be done
end

return CornerNode