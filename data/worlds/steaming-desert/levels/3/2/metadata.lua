local data = {
    name = "Small World",
    playerStart = {x = 3, y = 48},
    gameObjects = {
        ["00"] = {objectType = "bell", parameters = {}},
        ["01"] = {objectType = "door", parameters = {subLevelId = 1, playerPosition = {x = 2, y = 1}}}
    },
    background = "background-cave",
    midgrounds = { { name="midground-cave-1", paralaxDivider= 3}, { name="midground-cave-2", paralaxDivider= 2} },
    segmentHeight = 52,
    segmentLength = 32,
    yMin = 0,
    replaceTexture = "20"
}

return data