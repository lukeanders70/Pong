local data = {
    playerStart = {x = 3, y = 6},
    background = "background-cave",
    midgrounds = { { name="midground-cave-1", paralaxDivider= 3}, { name="midground-cave-2", paralaxDivider= 2} },
    gameObjects = {
        ["00"] = {objectType = "wellBelow", parameters = {subLevelId = 1, playerPosition = {x = 204, y = 1}}},
        ["01"] = {objectType = "wellBelow", parameters = {subLevelId = 3, playerPosition = {x = 2, y = 5}}},
        ["02"] = {objectType = "heartContainer", parameters = {}},
    },
    segmentHeight = 17,
    segmentLength = 26,
    yMin = 0
}

return data