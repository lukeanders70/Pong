local Node = require('src/world/Node')

local LevelNode = Class{__includes = Node}

function LevelNode:init(x, y, neighbors, levelId)
    self.levelId = levelId
    Node.init(self, x, y, neighbors)
end

function LevelNode:render()
    if self.state == Node.states.COMPLETE then
        love.graphics.setColor(100, 255, 100, 255)
    elseif self.state == Node.states.ACTIVE then
        love.graphics.setColor(255, 100, 100, 255)
    else
        return -- don't render inactive levels
    end
    love.graphics.rectangleScaled( "fill",  self.x, self.y, self.width, self.height )
    love.graphics.setColor(255, 255, 255, 255)
end

return LevelNode