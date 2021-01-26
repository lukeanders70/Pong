local Directions = require('src/objects/Directions')
local UITextureIndex = require("src/textures/UITextureIndex")

local  ButtonSet = Class{}

function ButtonSet:init(buttons)
    self.buttons = buttons
    self.activeButtonIndex = nil
    for i, button in ipairs(buttons) do
        if button.active then
            button:setHover()
            self.activeButtonIndex = i
            break
        end
    end
    self.active = true
end

function ButtonSet:inputHandleKeyPress(key)
    if self.active then
        if love.keyboard.isDown( 'w' ) then
            self:moveUp()
        elseif love.keyboard.isDown( 's' ) then
            self:moveDown()
        elseif love.keyboard.isDown('return') then
            self:press()
        end
    end
end

function ButtonSet:moveDown()
    if self.activeButtonIndex then
        local originalIndex = self.activeButtonIndex
        while self.buttons[self.activeButtonIndex + 1] do
            self.activeButtonIndex = self.activeButtonIndex + 1
            if self.buttons[self.activeButtonIndex].active then
                self.buttons[self.activeButtonIndex]:setHover()
                self.buttons[originalIndex]:setUnhover()
                return
            end
        end
    end
end

function ButtonSet:moveUp()
    if self.activeButtonIndex then
        local originalIndex = self.activeButtonIndex
        while self.buttons[self.activeButtonIndex - 1] do
            self.activeButtonIndex = self.activeButtonIndex - 1
            if self.buttons[self.activeButtonIndex].active then
                self.buttons[self.activeButtonIndex]:setHover()
                self.buttons[originalIndex]:setUnhover()
                return
            end
        end
    end
end

function ButtonSet:press()
    if self.activeButtonIndex and self.buttons[self.activeButtonIndex] then
        self.buttons[self.activeButtonIndex]:press()
    end
end

function ButtonSet:render()
    for i, button in ipairs(self.buttons) do
        button:render()
    end
    if self.activeButtonIndex and self.buttons[self.activeButtonIndex] then
        love.graphics.drawScaled(
            UITextureIndex.selector.texture,
            UITextureIndex.selector.quad,
            self.buttons[self.activeButtonIndex].x - 20,
            self.buttons[self.activeButtonIndex].y
        )
    end
end

return ButtonSet
