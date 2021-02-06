local Tile = require('src/level/Tiles')
local TileTextureIndex = require('src/textures/TileTextureIndex')
local ColliderTypes = require('src/objects/ColliderTypes')
local Animation = require('src/textures/Animation')

local BubblingTar = Class{__includes = Tile}

function BubblingTar:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isUpdateable = true
    self.numFrames = 7
    self.offFrames = 20
    self.randomFrameOffset = love.math.random(self.numFrames + self.offFrames)
    self.images = TileTextureIndex.animationFromId(self.id, self.numFrames)
end

function BubblingTar:update()
    local imageIndex = math.max(((GlobalState.timerValue + self.randomFrameOffset) % (self.numFrames + self.offFrames)) - self.offFrames, 0) + 1
    self.image = self.images[imageIndex]
end

local FallingRock = Class{__includes = Tile}

function FallingRock:init(indexX, indexY, id, isSolid, level)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isFalling = false
    self.isShaking = false
    self.isUpdateable = true

    local images = TileTextureIndex.animationFromId(self.id, 3)
    quads = {}
    for _, image in pairs(images) do
        table.insert(quads, image.quad)
    end
    self.breakAnimation = Animation(TileTextureIndex.texture, quads)
end

function FallingRock:update(dt)
    if (not self.falling) and (GlobalState.level) and (GlobalState.level.player) and (self:isDirectlyAbove(GlobalState.level.player)) then
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

    Timer.after(2, function()
        shakeTimer:remove()
        
        self.solid = false
        self.image = self.breakAnimation
        self.breakAnimation:cycleOnce(function()
            self.image = nil
            self.color = {0,0,0,0}
        end)
    end)
end

local Tar = Class{__includes = Tile}

function Tar:collide(collidable)
    if collidable.colliderType == ColliderTypes.CHARACTER then
        collidable:destroy(collidable, dt)
    end
end

local Sky = Class{__includes = Tile}

function Sky:init(indexX, indexY, id, isSolid)
    Tile.init(self, indexX, indexY, id, isSolid)
    self.isRendeable = false
    self.color = {0, 0, 0, 0}
end

return {
    [0] = Sky,
    [29] = BubblingTar,
    [28] = Tar,
    [37] = FallingRock
}