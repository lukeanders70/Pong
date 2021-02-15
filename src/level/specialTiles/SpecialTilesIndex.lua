local Sky = require('src/level/specialTiles/Sky')
local BubblingTar = require('src/level/specialTiles/BubblingTar')
local Tar = require('src/level/specialTiles/Tar')
local FallingRock = require('src/level/specialTiles/FallingRock')
local Cactus = require('src/level/specialTiles/Cactus')

return {
    [0] = Sky,
    [29] = BubblingTar,
    [28] = Tar,
    [37] = FallingRock,
    [42] = Cactus
}