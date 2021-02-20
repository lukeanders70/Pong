local GameObjectsMap = {}

function GameObjectsMap.loadClassFromName(gameObjectName)
    local gameObjectNameCap = gameObjectName:gsub("^%l", string.upper)
    local path = "src/objects/gameObjects/" .. gameObjectNameCap .. ".lua"
    local gameObjectClass = assert( love.filesystem.load(path) )()
    return gameObjectClass
end

return GameObjectsMap