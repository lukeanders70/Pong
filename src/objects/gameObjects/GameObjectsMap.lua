local GameObjectsMap = {
    ['00'] = "bell",
    ['01'] = "well",
    ['02'] = "wellBelow",
    ['03'] = "paddleBoy",
    ['04'] = "crawler"
}

function GameObjectsMap.loadClassFromName(gameObjectName) 
    local gameObjectNameCap = gameObjectName:gsub("^%l", string.upper)
    local path = "src/objects/gameObjects/" .. gameObjectNameCap .. ".lua"
    local gameObjectClass = assert( love.filesystem.load(path) )()
    return gameObjectClass
end

return GameObjectsMap