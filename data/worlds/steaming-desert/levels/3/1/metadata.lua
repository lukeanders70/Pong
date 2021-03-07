local data = {
    name = "Small World",
    playerStart = {x = 2, y = 9},
    gameObjects = {
        ["00"] = {objectType = "door", parameters = {subLevelId = 2, playerPosition = {x = 2, y = 1}}}
    },
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    segmentHeight = 19,
    segmentLength = 26,
    yMin = 0
}

return data