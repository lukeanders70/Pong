local Image = Class{}

function Image.createFromName(name)
    local texture = love.graphics.newImage('assets/' .. name .. '.png')
    local width, height = texture:getDimensions()
    return Image(texture, love.graphics.newQuad(0, 0, width, height, texture:getDimensions()))
end

function Image:init(texture, quad)
    self.width, self.height = texture:getDimensions()
    self.texture = texture
    self.quad = quad
end

return Image