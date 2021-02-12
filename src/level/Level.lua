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
        yMax = self.subLevel.yMax - Constants.VIRTUAL_HEIGHT
    })

    self.levelCompleted = false
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

function Level:render()
    self.subLevel:render()
end

function Level:update(dt)
    self.subLevel:update(dt)
end

return Level