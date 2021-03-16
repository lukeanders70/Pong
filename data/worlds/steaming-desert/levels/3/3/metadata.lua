local data = {
    name = "Small World",
    playerStart = {x = 16, y = 93},
    gameObjects = {
        ["01"] = {objectType = "bell", parameters = {}},
        ["00"] = {objectType = "door", parameters = {subLevelId = 2, playerPosition = {x = 3, y = 6}}}
    },
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    segmentHeight = 105,
    segmentLength = 32,
    replaceTexture = "11"
}

return data