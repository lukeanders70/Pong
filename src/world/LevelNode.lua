local Node = require('src/world/Node')

local LevelNode = Class{__includes = Node}

function LevelNode:init(x, y, neighbors, levelId)
    self.complete = false
    self.levelId = levelId
    Node.init(self, x, y, neighbors)
    
end

function LevelNode:render()
    if self.complete then
        love.graphics.setColor(100, 255, 100, 255)
    else
        love.graphics.setColor(255, 100, 100, 255)
    end
    love.graphics.rectangleScaled( "fill",  self.x, self.y, self.width, self.height )

    love.graphics.setColor(255, 255, 255, 255)
end

return LevelNode