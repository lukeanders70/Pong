local Image = require('src/textures/Image')
local State = require("src/states/State")
local Renderable = require('src/objects/Renderable')

local HeartContainer = Class{}

function HeartContainer:init(numHearts, timerGroup, callback)
    self.numHearts = numHearts
    self.numVisible = 0
    self.heartImage = Image.createFromName("heart")
    self.timerGroup = timerGroup

    self.callback = callback
end

function HeartContainer:reveal()
    print(self.numHearts)
    Timer.every(0.3, function()
        self.numVisible = self.numVisible + 1
    end):limit(self.numHearts):group(self.timerGroup):finish(self.callback)
end

function HeartContainer:render()
    local y = 143
    local x = 273
    for i = 1, math.min(self.numVisible, self.numHearts) do 
        love.graphics.drawScaled( self.heartImage.texture, self.heartImage.quad, x, y)
        x = x + 54
    end
end

local LevelCompleteState = Class{__includes = State}

function LevelCompleteState:init()
    State.init(self)
end

function LevelCompleteState:enter(params)
    self.levelCompleteTimerGroup = {}

    self.callback = params.callback
    self.numHearts = params.numHearts or 0
    self.image = Image.createFromName("victory")
    self.hearts = nil
    
    self.canDismiss = false

    self.scaleX = 0
    self.scaleY = 0
    self.xOffset = Constants.VIRTUAL_WIDTH / 2
    self.yOffset = Constants.VIRTUAL_HEIGHT / 2

    self.heartContainer = HeartContainer(self.numHearts, self.levelCompleteTimerGroup, function()
        self.canDismiss = true
    end)
    
    Timer.tweenSqr(0.5, {
        [self] = { scaleX = 1, xOffset = 0, scaleY = 1, yOffset = 0}
    }):finish(function()
        Timer.after(0.2, function()
            self.heartContainer:reveal()
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
    love.graphics.drawScaled(self.image.texture, self.image.quad, self.xOffset, self.yOffset, 0, self.scaleX, self.scaleY)
    self.heartContainer:render()
end

function LevelCompleteState:update(dt)
    Timer.update(dt, self.levelCompleteTimerGroup)
    State.update(self, dt)
end

function LevelCompleteState:exit()
    Timer.clear(self.levelCompleteTimerGroup)
    GlobalState.timerValue = 0
    GlobalState.timerGroup = nil
end

return LevelCompleteState