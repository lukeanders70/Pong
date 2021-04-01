local data = {
    playerStart = {x = 2, y = 5},
    background = "background-cave",
    midgrounds = { { name="midground-cave-1", paralaxDivider= 3}, { name="midground-cave-2", paralaxDivider= 2} },
    gameObjects = {
        ["00"] = {objectType = "wellBelow", parameters = {subLevelId = 1, playerPosition = {x = 278, y = 2}}},
        ["01"] = {objectType = "heartContainer", parameters = {}},
        ["02"] = {objectType = "wellBelow", parameters = {subLevelId = 3, playerPosition = {x = 2, y = 7}}},
    },
    segmentHeight = 17,
    segmentLength = 26,
    yMin = 0
}

return data