local Renderable = require('src/objects/Renderable')

local CursorButton = Class{__includes = Renderable}

function CursorButton:init(hoveredImage, unhoveredImage, x, y, active, clickFunction)
    self.hovered = false
    self.hoveredImage = hoveredImage
    self.unhoveredImage = unhoveredImage
    Renderable.init(self, x, y, self.unhoveredImage.width, self.unhoveredImage.height)
    self.image = self.unhoveredImage

    self.clickFunction = clickFunction or function() return end

    if not active then
        self:setInactive()
    else
        self:setActive()
    end
end

function CursorButton:setHover()
    self.hovered = true
    self.image = self.hoveredImage
    self.width = self.hoveredImage.width
    self.height = self.hoveredImage.height
end

function CursorButton:setUnhover()
    self.hovered = false
    self.image = self.unhoveredImage
    self.width = self.unhoveredImage.width
    self.height = self.unhoveredImage.height
end

function CursorButton:setInactive()
    self:setUnhover()
    self.active = false
    self.color = Constants.colors.lightGrey
end

function CursorButton:setActive()
    self.active = true
    self.color = Constants.colors.white
end

function CursorButton:press()
    self.clickFunction()
end

return CursorButton
