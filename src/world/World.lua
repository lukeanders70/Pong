local Image = require('src/textures/Image')
local PathGraph = require('src/world/PathGraph')
local OverworldPlayer = require('src/world/OverworldPlayer')

local World = Class{}

World.defaultMetaData = {
    name_display = "Steaming Desert",
    name = "steaming-desert",
    playerStart = {x = 2, y = 1},
    map = "world1",
    nodes = {},
    paths = {}
}
function World:init(name)

    self.name = name

    local path = "data/worlds/" .. self.name .. "/"
    self.metadata = World.safeLoadMetaData(path .. "metadata.lua")

    -- images
    self.mapImage = Image.createFromName(self.metadata.map)

    self.pathGraph = PathGraph(self.metadata.nodes, self.metadata.paths, self)
    self.player = OverworldPlayer(self.pathGraph.nodes[1], self)
end

function World.safeLoadMetaData(path)
    local ok, chunk = pcall( love.filesystem.load, path )
    if not ok then
        logger('e', "failed to find world at path: " .. path .. ": " .. tostring(path))
        return World.defaultMetaData
    end

    local ok, result = pcall(chunk) -- execute the chunk safely
    if not ok then -- will be false if there is an error
        print(result)
        logger('e', "failed to load world at path: " .. path ..": " .. tostring(result))
        return World.defaultMetaData
    end

    return result
end


function World:startLevel(node)
    if node and node.levelId then
        GlobalState.stateMachine:swap('play', {levelId = node.levelId, worldName = self.metadata.name})
    end
end

function World:inputHandleKeyPress(key)
    self.player:inputHandleKeyPress(key)
end

function World:render()
    love.graphics.drawScaled( self.mapImage.texture, self.mapImage.quad, 0, 0)
    self.pathGraph:render()
    self.player:render()
end

return World