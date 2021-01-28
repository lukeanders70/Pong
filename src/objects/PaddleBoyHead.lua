local ObjectTextureIndex = require('src/textures/ObjectTextureIndex')
local Renderable = require('src/objects/Renderable')

local  PaddleBoyHead = Class{__includes = Renderable}

PaddleBoyHead.PADDLE_WIDTH = 3
function PaddleBoyHead:init(parent, yOffset)
    Renderable.init(self, parent.x, parent.y + yOffset, 20, 20)

    self.yOffset = yOffset
    self.parent = parent

    self.image = ObjectTextureIndex.getAnimation('paddle-boy-head', self.width, self.height, self.parent.timerGroup)

end

function PaddleBoyHead:attackAnimation()
    self.image:cycleOnce()
end

function PaddleBoyHead:update(dt, moveY)
    self.x = self.parent.x
    self.y = self.parent.y + self.yOffset
end

return PaddleBoyHead