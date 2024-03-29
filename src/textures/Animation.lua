local Animation = Class{}

-- creates an animation by generating quads from a texture based on image dimenstions
-- textures should always have animations horizontal, going from left to right
Animation.frameDelay = 0.15
function Animation.create(texture, imageheight, imageWidth, timerGroup)
    local textureX, textureY = texture:getDimensions()
    if (textureX % imageWidth ~= 0) then
        logger('w', 'animation processed with image width [' .. imageWidth .. '] failed to divide into texture width [' .. tostring(textureX) .. ']')
        return nil
    end
    local quads = {}
    local xOffset = 0
    while ( xOffset < textureX ) do
        table.insert(quads,
            love.graphics.newQuad(
                xOffset,
                0,
                imageWidth,
                imageheight,
                texture:getDimensions()
            )
        )
        xOffset = xOffset + imageWidth
    end
    return Animation(texture, quads, timerGroup)
end

function Animation:init(texture, quads, timerGroup)
    self.texture = texture
    self.quads = quads
    self.currentFrame = 1
    self.numFrames = #quads
    self.quad = quads[self.currentFrame]
    self.timerGroup = timerGroup

    self.currentTimer = nil
end

function Animation:cycleOnce(callback)
    if self.currentTimer then
        self.currentTimer:remove()
        self.currentTimer = nil
    end

    self:setFrame(1)
    self.currentTimer = Timer.every(self.frameDelay, function()
        self:cycle()
    end):limit(self.numFrames):group(self.timerGroup)

    if callback and type(callback) == 'function' then
        self.currentTimer:finish(callback)
    end
end

function Animation:continousCycling()
    if self.currentTimer then
        self.currentTimer:remove()
        self.currentTimer = nil
    end

    self:setFrame(1)
    self.currentTimer = Timer.every(self.frameDelay, function()
        self:cycle()
    end):group(self.timerGroup)
end

function Animation:cycle()
    if self.currentFrame >= self.numFrames then
        self:setFrame(1)
    else
        self:setFrame(self.currentFrame + 1)
    end
end

function Animation:stopCycle()
    if self.currentTimer then
        self.currentTimer:remove()
        self.currentTimer = nil
        self:setFrame(1)
    end
end

function Animation:setFrame(frameNumber)
    if self.quads[frameNumber] then
        self.quad = self.quads[frameNumber]
        self.currentFrame = frameNumber
    else
        logger('e', 'tried to set animation to unavailable frame number: ' .. tostring(frameNumber))
    end
end

return Animation