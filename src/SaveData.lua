local json = require('lib/json')

local SaveData = Class{}

SaveData.defaultSaveLocation = "save"
function SaveData:init(fromPath)
    if fromPath then
        self.data = SaveData.loadData(path)
    else
        self.data = {}
    end
end

function SaveData:levelComplete(worldName, id)
    if self.data[worldName] then
        self.data[worldName][id] = true
    else
        self.data[worldName] = {}
        self.data[worldName][id] = true
    end
end

function SaveData:isLevelComplete(worldName, id)
    return self.data[worldName] and self.data[worldName][id]
end

function SaveData:loadData()
    if love.filesystem.exists( SaveData.defaultSaveLocation ) then
        local contents, size = love.filesystem.read( SaveData.defaultSaveLocation )
        local j = json.decode(contents)
        return j or {}
    else
        return {}
    end
end

function SaveData:save()
    local j = json.encode(self.data)
    print("about to write to filesystem: " .. tostring(j))
    love.filesystem.write( SaveData.defaultSaveLocation, j )
end

return SaveData