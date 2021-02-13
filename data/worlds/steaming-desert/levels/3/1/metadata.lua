local data = {
    name = "Small World",
    playerStart = {x = 2, y = 1},
    endBell = {x = 150, y = 8},
    gameObjects = {
        ["00"] = {objectType = "bell", parameters = {}},
        ["01"] = {objectType = "well", parameters = {subLevelId = 2, playerPosition = {x = 2, y = 1}}}
    },
    background = "background-2",
    midgrounds = { { name="midground-2-1", paralaxDivider= 3}, { name="midground-2-2", paralaxDivider= 2} },
    segmentHeight = 13,
    segmentLength = 26
}

return data