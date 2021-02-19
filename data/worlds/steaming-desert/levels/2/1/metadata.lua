local data = {
    playerStart = {x = 2, y = 1},
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    gameObjects = {
        ["00"] = {objectType = "well", parameters = {subLevelId = 2, playerPosition = {x = 3, y = 6}}},
        ["01"] = {objectType = "heartContainer", parameters = {}}
    },
    segmentHeight = 13,
    segmentLength = 26
}

return data