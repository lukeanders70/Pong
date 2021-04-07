local data = {
    name = "Small World",
    playerStart = {x = 17, y = 114},
    gameObjects = {
        ["00"] = {objectType = "door", parameters = {subLevelId = 3, playerPosition = {x = 16, y = 93}}},
        ["01"] = {objectType = "door", parameters = {subLevelId = 1, playerPosition = {x = 154, y = 14}}},
        ["02"] = {objectType = "heartContainer", parameters = {}},
    },
    background = "background-cave",
    midgrounds = { { name="midground-cave-1", paralaxDivider= 3}, { name="midground-cave-2", paralaxDivider= 2} },
    segmentHeight = 119,
    segmentLength = 32,
    yMin = 0,
    replaceTexture = "20"
}

return data