local Image = require('src/textures/Image')
local PathGraph = require('src/world/PathGraph')

local World = Class{}

World.defaultMetaData = {
    name = "Steaming Desert",
    playerStart = {x = 2, y = 1},
    map = "world1",
    nodes = {},
    paths = {}
}
function World:init(name)

    local path = "data/worlds/" .. name .. "/"
    self.metadata = World.safeLoadMetaData(path .. "metadata.lua")

    -- images
    self.mapImage = Image.createFromName(self.metadata.map)
    self.pathGraph = PathGraph(self.metadata.nodes, self.metadata.paths)
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

function World:render()
    love.graphics.drawScaled( self.mapImage.texture, self.mapImage.quad, 0, 0)
    self.pathGraph:render()
end

return World