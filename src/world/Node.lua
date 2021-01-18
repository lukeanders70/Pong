local Node = Class{}

Node.WIDTH = 5
Node.HEIGHT = 3
function Node:init(x, y, neighbors)
    self.x = x
    self.y = y
    self.neighbors = neighbors

    self.left = nil
    self.right = nil
    self.above = nil
    self.below = nil

    self.width = Node.WIDTH
    self.height = Node.HEIGHT
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

function Node:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangleScaled( "fill",  self.x, self.y, self.width, self.height )
end

return Node