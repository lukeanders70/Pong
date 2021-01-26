local Image = require('src/textures/Image')

local  UITextureIndex = {}

 UITextureIndex.baseTexture = love.graphics.newImage('assets/ui.png')
 UITextureIndex.continueHover = Image(
     UITextureIndex.baseTexture,
    love.graphics.newQuad(
        0,
        0,
        125,
        15,
         UITextureIndex.baseTexture:getDimensions()
    )
)
 UITextureIndex.continue = Image(
     UITextureIndex.baseTexture,
    love.graphics.newQuad(
        0,
        15,
        125,
        15,
         UITextureIndex.baseTexture:getDimensions()
    )
)
UITextureIndex.newGameHover = Image(
     UITextureIndex.baseTexture,
    love.graphics.newQuad(
        0,
        30,
        125,
        15,
         UITextureIndex.baseTexture:getDimensions()
    )
)
UITextureIndex.newGame = Image(
     UITextureIndex.baseTexture,
    love.graphics.newQuad(
        0,
        45,
        125,
        15,
         UITextureIndex.baseTexture:getDimensions()
    )
)

return  UITextureIndex