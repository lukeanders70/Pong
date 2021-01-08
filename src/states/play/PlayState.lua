local Level = require("src/level/Level")
local State = require("src/states/State")

local PlayState = Class{__includes = State}

function PlayState:init()
    State.init(self)
end

function PlayState:enter(params)
    local levelId = getOrElse(params, "levelId", 1, "PlayState level id not found in params")
    self.level = Level(levelId)
    self.player = self.level.player
    self:addRenderable(self.level)
    self:addUpdateable(self.level)

    GlobalState.camera:setLimits({
        xMin = 0,
        xMax = math.max(self.level:xMax() - Constants.VIRTUAL_WIDTH, 0),
        yMax = self.level:yMax() - Constants.VIRTUAL_HEIGHT
    })
end

function PlayState:updateCallback()
    GlobalState.camera:centerOnObject(self.player)
end

return PlayState
