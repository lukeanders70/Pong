local Level = require("src/level/Level")
local State = require("src/states/State")

local PlayState = Class{__includes = State}

function PlayState:init()
    State.init(self)
end

function PlayState:enter(params)

    self.levelTimerGroup = {}
    GlobalState.timerGroup = self.levelTimerGroup
    GlobalState.timerValue = 0
    self.levelTimer = Timer.every(0.3, function()
        GlobalState.timerValue = GlobalState.timerValue + 1
        if GlobalState.timerValue > 10000 then
            GlobalState.timerValue = 0
        end
    end):group(self.levelTimerGroup)

    local levelId = getOrElse(params, "levelId", "1", "PlayState level id not found in params")
    local worldName = getOrElse(params, "worldName", "steaming-desert")
    self.level = Level(worldName, levelId)
    self.player = self.level.player
    self:addRenderable(self.level)
    self:addUpdateable(self.level)
end

function PlayState:update(dt)
    Timer.update(dt, self.levelTimerGroup)
    State.update(self, dt)
end

function PlayState:inputHandleKeyPress(key)
    if key == "escape" then
        GlobalState.stateMachine:add("pause", {level = self.level})
    else
        self.player:inputHandleKeyPress(key)
    end
end

function PlayState:updateCallback()
    GlobalState.camera:centerOnObject(self.player)
end

function PlayState:exit()
    Timer.clear(self.levelTimerGroup)
    GlobalState.timerValue = 0
    GlobalState.timerGroup = nil
end

return PlayState
