local EnemyMap = {
    ['00'] = "turret",
    ['01'] = "flappy",
    ['02'] = "vertigo",
    ['03'] = "paddleBoy",
    ['04'] = "crawler",
    ['05'] = "turret",
    ['06'] = "crawlerBlue"
}

function EnemyMap.loadClassFromName(enemyName) 
    local enemyNameCap = enemyName:gsub("^%l", string.upper)
    local path = "src/characters/" .. enemyNameCap .. ".lua"
    local enemyClass = assert( love.filesystem.load(path) )()
    return enemyClass
end

return EnemyMap