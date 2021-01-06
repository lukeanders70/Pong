local Image = require('src/textures/Image')
local Animation = require('src/textures/Animation')

local CharacterTextureIndex = {}

CharacterTextureIndex.staticImageCache = {}
CharacterTextureIndex.animationTextureCache = {}
CharacterTextureIndex.numColumns = 3
function CharacterTextureIndex.fromCharacterName(name, characterWidth, characterHeight, isAnimation)

    -- is an image
    if (not isAnimation) then
        return CharacterTextureIndex.getImage(name, characterWidth, characterHeight)
    -- is an animation
    else    
        return CharacterTextureIndex.getAnimation(name, characterWidth, characterHeight)
    end
end

function CharacterTextureIndex.getImage(name, characterWidth, characterHeight)
    -- if it's a static image, cache stores the full image
    if CharacterTextureIndex.staticImageCache[name] then
        return CharacterTextureIndex.staticImageCache[name]
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
    CharacterTextureIndex.staticImageCache[name] = image
    return image
end

function CharacterTextureIndex.getAnimation(name, characterWidth, characterHeight)
    -- if it's an animation, cache stores the just the texture (since)
    local texture
    if CharacterTextureIndex.animationTextureCache[name] then
        texture = CharacterTextureIndex.animationTextureCache[name]
    else
        texture = love.graphics.newImage('assets/' .. name .. '.png')
        CharacterTextureIndex.animationTextureCache[name] = texture
    end

    return Animation.create(texture, characterHeight, characterWidth)
end

return CharacterTextureIndex