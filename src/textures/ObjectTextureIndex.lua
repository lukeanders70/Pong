local Image = require('src/textures/Image')
local Animation = require('src/textures/Animation')

local ObjectTextureIndex = {}

ObjectTextureIndex.staticImageCache = {}
ObjectTextureIndex.animationTextureCache = {}
ObjectTextureIndex.numColumns = 3

function ObjectTextureIndex.getImage(name, characterWidth, characterHeight)
    -- if it's a static image, cache stores the full image
    if ObjectTextureIndex.staticImageCache[name] then
        return ObjectTextureIndex.staticImageCache[name]
    end

    local texture = love.graphics.newImage('assets/' .. name .. '.png')

    local quad = love.graphics.newQuad(
        0,
        0,
        characterWidth,
        characterHeight,
        texture:getDimensions()
    )
    local image = Image(texture, quad)
    ObjectTextureIndex.staticImageCache[name] = image
    return image
end

function ObjectTextureIndex.getAnimation(name, characterWidth, characterHeight, timerGroup)
    -- if it's an animation, cache stores the just the texture (since)
    local texture
    if ObjectTextureIndex.animationTextureCache[name] then
        texture = ObjectTextureIndex.animationTextureCache[name]
    else
        texture = love.graphics.newImage('assets/' .. name .. '.png')
        ObjectTextureIndex.animationTextureCache[name] = texture
    end

    return Animation.create(texture, characterHeight, characterWidth, timerGroup)
end

return ObjectTextureIndex