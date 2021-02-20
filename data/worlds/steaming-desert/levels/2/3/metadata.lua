local data = {
    playerStart = {x = 2, y = 5},
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    gameObjects = {
        ["00"] = {objectType = "well", parameters = {subLevelId = 2, playerPosition = {x = 388, y = 6}}},
        ["01"] = {objectType = "bell", parameters = {}}
    },
    segmentHeight = 13,
    segmentLength = 26
}

return data