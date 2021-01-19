local Node = require('src/world/Node')

local Path = Class{}

Path.PATH_WIDTH = 1
function Path:init(firstNode, secondNode)
    self.firstNode = firstNode
    self.secondNode = secondNode
    if firstNode.x == secondNode.x then
        self.orientation = "vertical"
    elseif firstNode.y == secondNode.y then
        self.orientation = "horizontal"
    else
        self.orientation = "vertical"
        logger('e', "path between nodes not cardinal: {" .. firstNode.x .. ", " .. firstNode.y .. "}" .. " -> {" .. secondNode.x .. ", " .. secondNode.y .. "}")
    end
    if self.orientation == "vertical" then
        self.x = math.min(firstNode.x, secondNode.x) + math.floor(Node.WIDTH / 2)
        self.y = math.min(firstNode.y, secondNode.y)
    else
        self.x = math.min(firstNode.x, secondNode.x)
        self.y = math.min(firstNode.y, secondNode.y) + math.floor(Node.HEIGHT / 2)
    end
    self.height = math.max(math.max(firstNode.y, secondNode.y) - self.y, Path.PATH_WIDTH)
    self.width = math.max(math.max(firstNode.x, secondNode.x) - self.x, Path.PATH_WIDTH)
end

function Path:shouldRender()
    return (self.firstNode.state == Node.states.COMPLETE) or (self.secondNode.state == Node.states.COMPLETE)
end

function Path:render()
    if self:shouldRender() then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.rectangleScaled( "fill", self.x, self.y, self.width, self.height)
    end
end

return Path