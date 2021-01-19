local LevelNode = require('src/world/LevelNode')
local CornerNode = require('src/world/CornerNode')
local Path = require('src/world/Path')

local PathGraph = Class{}

function PathGraph:init(nodesData, pathsData, world)
    self.world = world
    self.nodes = {}
    for _, nodeData in pairs(nodesData) do
        if nodeData.type == "level" then
            table.insert(self.nodes, LevelNode(nodeData.x, nodeData.y, {}, nodeData.id, self))
        elseif nodeData.type == "corner" then
            table.insert(self.nodes, CornerNode(nodeData.x, nodeData.y, {}, self))
        else
            logger('e', 'Node has unknown type: ' .. nodeData.type)
        end
    end

    self.paths = {}
    for _, pathData in pairs(pathsData) do
        local node1 = self.nodes[pathData[1]]
        local node2 = self.nodes[pathData[2]]
        node1:addNeighbor(node2)
        node2:addNeighbor(node1)
        table.insert(self.paths, Path(node1, node2))
    end

    if #self.nodes > 0 then
        self.nodes[1]:setComplete()
    end
end

function PathGraph:render()
    for _, path in pairs(self.paths) do
        path:render()
    end

    for _, node in pairs(self.nodes) do
        node:render()
    end
end

return PathGraph