local Node = Class{}

Node.WIDTH = 5
Node.HEIGHT = 3
Node.states = {
    INACTIVE = "inactive",
    COMPLETE = "complete",
    ACTIVE = "active"
}
function Node:init(x, y, neighbors, graph)
    self.graph = graph
    
    self.x = x
    self.y = y
    self.neighbors = neighbors

    self.left = nil
    self.right = nil
    self.above = nil
    self.below = nil

    self.width = Node.WIDTH
    self.height = Node.HEIGHT

    self.state = Node.states.INACTIVE
end

function Node:addNeighbor(node)
    if not((node.x == self.x) or (node.y == self.y)) then
        logger('e', "path between nodes not cardinal: {" .. node.x .. ", " .. node.y .. "}" .. " -> {" .. self.x .. ", " .. self.y .. "}")
        return
    end
    if node.x < self.x then
        self.left = node
    elseif node.x > self.x then
        self.right = node
    elseif node.y < self.y then
        self.above = node
    elseif node.y > self.y then
        self.below = node
    else
        logger('w', 'failed to add node as neighbor, same position')
        return
    end
    table.insert(self.neighbors, node)
end

function Node:setComplete()
    self.state = Node.states.COMPLETE
    for _, node in pairs(self.neighbors) do
        node:setActive()
    end
end

function Node:setActive()
    if not (self.state == Node.states.COMPLETE) then
        self.state = Node.states.ACTIVE
    end
end

function Node:isMovable()
    return (self.state == Node.states.COMPLETE) or (self.state == Node.states.ACTIVE)
end

function Node:render()
    if (self.state == Node.states.ACTIVE) or (self.states == Node.states.COMPLETE) then
        love.graphics.rectangleScaled( "fill",  self.x, self.y, self.width, self.height )
    end
end

return Node