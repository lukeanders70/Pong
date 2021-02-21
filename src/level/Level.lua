local SubLevel = require('src/level/SubLevel')
local Player = require('src/characters/Player')

local Level = Class{}

Level.defaultMetaData = {name="Default Level", playerStart={x = 0, y = 1}}
Level.levelCompleteWait = 2 -- seconds
Level.levelCompleteMotionSlowMultipler = 0.25

function Level:init(worldName, id)
    GlobalState.level = self
    self.worldName = worldName
    self.id = id
    self.subLevel = SubLevel(self.worldName, self, 1)
    self.player = Player(0, 0)
    self.subLevel:placePlayer()
    GlobalState.camera:setLimits({
        xMin = 0,
        xMax = math.max(self.subLevel.xMax - Constants.VIRTUAL_WIDTH, 0),
        yMax = self.subLevel.yMax - Constants.VIRTUAL_HEIGHT,
        yMin = self.subLevel.yMin,
    })

    self.levelCompleted = false
    self.shouldRenderLevel = true
    self:warpAnimation(Constants.VIRTUAL_HEIGHT, 0, function()
        self.shouldUpdateLevel = true
    end)
end

function Level:levelComplete()
    if not self.levelCompleted then
        Timer.after(self.levelCompleteWait, function()
            GlobalState.saveData:levelComplete(self.worldName, self.id)
            GlobalState.saveData:save()
            GlobalState.stateMachine:add('levelComplete', {callback = function()
                GlobalState.stateMachine:swap('map', {worldName = self.worldName})
                GlobalState.subLevel = nil
            end})
        end)
    end
    self.levelCompleted = true
end

function Level:levelFailed()
    GlobalState.stateMachine:swap('map', {worldName = self.worldName})
    self.levelComplete = true
end

function Level.safeLoadMetaData(worldName, levelId)
    local path = "data/worlds/" .. worldName .. "/levels/" .. levelId .. "/" .. "metadata.lua"
    local ok, chunk = pcall( love.filesystem.load, path )
    if not ok then
        logger('e', "failed to find level at path: " .. path .. ": " .. tostring(path))
        return Level.defaultMetaData
    end

    local ok, result = pcall(chunk) -- execute the chunk safely
    if not ok then -- will be false if there is an error
        logger('e', "failed to load level at path: " .. path ..": " .. tostring(result))
        return Level.defaultMetaData
    end

    return result
end

function Level:swapSubLevel(subLevelId, playerPosition)
    self.shouldUpdateLevel = false
    self:warpAnimation(0, Constants.VIRTUAL_HEIGHT, function()
        local newSubLevel = SubLevel(self.worldName, self, subLevelId)
        self.subLevel = newSubLevel
        self.subLevel:placePlayer(playerPosition)
        GlobalState.camera:setLimits({
            xMin = 0,
            xMax = math.max(self.subLevel.xMax - Constants.VIRTUAL_WIDTH, 0),
            yMax = self.subLevel.yMax - Constants.VIRTUAL_HEIGHT,
            yMin = self.subLevel.yMin
        })
        self:warpAnimation(Constants.VIRTUAL_HEIGHT, 0, function()
            self.shouldUpdateLevel = true
        end)
    end)
end

function Level:warpAnimation(startHeight, endHeight, callback)
    self.transition = {
        height = startHeight,
        render = function()
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.rectangleScaled( "fill",  0, 0, Constants.VIRTUAL_WIDTH, self.transition.height )
            love.graphics.setColor(255, 255, 255, 255)
        end
    }
    Timer.tween(0.5, {
        [self.transition] = { height = endHeight }
    }):finish(function()
        Timer.after(0.2, function()
            self.transition = nil
            callback()
        end)
    end)
end

function Level:render()
    if self.shouldRenderLevel then
        self.subLevel:render()
    end
    if self.transition then
        self.transition:render()
    end
end

function Level:update(dt)
    if self.shouldUpdateLevel then
        self.subLevel:update(dt)
    end
end

return Level