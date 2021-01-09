local Midground = Class{}

function Midground:init(image, paralaxDivider)
    self.image = image
    self.paralaxDivider = paralaxDivider
end

function Midground:render()
    local xOffset = math.fmod((GlobalState.camera.x_offest / self.paralaxDivider), self.image.width)
    while xOffset < Constants.VIRTUAL_WIDTH do
        love.graphics.draw(self.image.texture, xOffset, 0)
        xOffset = xOffset + self.image.width
    end
end

return Midground