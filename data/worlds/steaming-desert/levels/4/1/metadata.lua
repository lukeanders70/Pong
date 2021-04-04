local data = {
    name = "House",
    playerStart = {x = 2, y = 8},
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    gameObjects = {
        ["00"] = {objectType = "well", parameters = {subLevelId = 2, playerPosition = {x = 3, y = 4}}},
    },
    segmentHeight = 16,
    segmentLength = 26
}

return data