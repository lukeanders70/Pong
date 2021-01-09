local Image = require('src/textures/Image')

local basicTextures = {}

basicTextures.baseTexture = love.graphics.newImage('assets/basics.png')
basicTextures.paddle = Image(
    basicTextures.baseTexture,
    love.graphics.newQuad(
        0,
        0,
        3,
        20,
        basicTextures.baseTexture:getDimensions()
    )
)
basicTextures.smallBall = Image(
    basicTextures.baseTexture,
    love.graphics.newQuad(
        2,
        0,
        4,
        4,
        basicTextures.baseTexture:getDimensions()
    )
)
basicTextures.largeBall = Image(
    basicTextures.baseTexture,
    love.graphics.newQuad(
        2,
        3,
        4,
        4,
        basicTextures.baseTexture:getDimensions()
    )
)

return basicTextures