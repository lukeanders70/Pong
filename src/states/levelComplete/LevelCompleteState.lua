local Image = require('src/textures/Image')
local State = require("src/states/State")
local Renderable = require('src/objects/Renderable')

local LevelCompleteState = Class{__includes = State}

function LevelCompleteState:init()
    State.init(self)
end

function LevelCompleteState:enter(params)
    self.callback = params.callback
    self.image = Image.createFromName("victory")
    
    self.canDismiss = false

    self.imageY = - Constants.VIRTUAL_HEIGHT
    
    Timer.tween(1, {
        [self] = { imageY = 0 }
    }):finish(function() 
        Timer.after(0.5, function()
            self.canDismiss = true
        end)
    end)
end

function LevelCompleteState:inputHandleKeyPress(key)
    if self.canDismiss and (key == "return") then
        GlobalState.stateMachine:remove()
        if self.callback then
            self.callback()
        end
    end
end

function LevelCompleteState:render()
    love.graphics.drawScaled(self.image.texture, self.image.quad, 0, self.imageY)
end

return LevelCompleteState