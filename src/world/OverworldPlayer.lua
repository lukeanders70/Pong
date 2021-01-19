local Image = require('src/textures/Image')

local OverworldPlayer = Class{}

function OverworldPlayer:init(node, world)
    self.world = world

    self.image = Image.createFromName("overworld-player")
    self.width = self.image.width
    self.height = self.image.height

    self.node = node

    if self.node then
        self.x = self:xFromNode(node)
        self.y = self:yFromNode(node)
    else
        self.x = 0
        self.y = 0
    end
    self.moving = false
end

function OverworldPlayer:xFromNode(node)
    return node.x - math.ceil((self.width - node.width) / 2)
end

function OverworldPlayer:yFromNode(node)
    return node.y - self.height + 2
end

function OverworldPlayer:update()
    if (not self.moving) and (self.node) then

        local moveNode

        if love.keyboard.isDown( 'w' ) then
            moveNode = self.node.above
        elseif love.keyboard.isDown( 'a' ) then
            moveNode = self.node.left
        elseif love.keyboard.isDown( 's' ) then
            moveNode = self.node.below
        elseif love.keyboard.isDown( 'd' ) then
            moveNode = self.node.right
        elseif love.keyboard.isDown( 'return' ) then
            self.world:startLevel(self.node)
            return
        end

        if moveNode and moveNode:isMovable() then
            self:moveToNode(moveNode)
        end
    end
end

function OverworldPlayer:moveToNode(newNode)
    self.moving = true
    Timer.tween(0.2, {
        [self] = { x = self:xFromNode(newNode), y = self:yFromNode(newNode) }
    }):finish(function()
        self.node = newNode
        self.moving = false
    end)
end

function OverworldPlayer:render()
    love.graphics.drawScaled(self.image.texture, self.image.quad, self.x, self.y)
end

return OverworldPlayer