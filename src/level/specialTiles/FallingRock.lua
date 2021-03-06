local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')
local Animation = require('src/textures/Animation')

local FallingRock = Class{__includes = Tile}

FallingRock.SHAKE_TIME = 2
FallingRock.REFORM_TIME = 5
function FallingRock:init(indexX, indexY, id, isSolid, level)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isFalling = false
    self.isShaking = false
    self.isUpdateable = true

    local replaceID = tonumber(Tile.removeZeroPrefix(GlobalState.subLevel.metaData.replaceTexture or '00'))
    self.replaceTexture = TileTextureIndex.fromId(20)

    local images = TileTextureIndex.animationFromId(self.id, 3)
    quads = {}
    for _, image in pairs(images) do
        table.insert(quads, image.quad)
    end
    self.breakAnimation = Animation(TileTextureIndex.texture, quads)
    self.originalImage = self.image
end

function FallingRock:steppedOn(character, dt)
    if not self.isFalling then
        self:triggerFall()
    end
end

function FallingRock:triggerFall()
    self.isFalling = true
    self.isUpdateable = false
    self.xRenderOffset = 0.5
    
    local shakeTimer = Timer.every(0.1, function()
        self.xRenderOffset = self.xRenderOffset * (-1)
    end):group(GlobalState.timerGroup)

    Timer.after(FallingRock.SHAKE_TIME, function()
        shakeTimer:remove()
        
        self.image = self.breakAnimation
        self.breakAnimation:cycleOnce(function()
            self.solid = false
            self.image = nil
            self.color = {0,0,0,0}
            self:triggerReform()
        end)
    end)
end

function FallingRock:triggerReform()
    Timer.after(FallingRock.REFORM_TIME, function()
        self.isFalling = false
        self.isUpdateable = true
        self.xRenderOffset = 0
        self.solid = true
        self.image = self.originalImage
        self.color = {255, 255, 255, 255}
    end)
end

function FallingRock:render()
    GlobalState.camera:draw(self.replaceTexture.texture, self.replaceTexture.quad, self.x, self.y)
    Tile.render(self)
end

return FallingRock