local Image = Class{}

function Image:init(texture, quad)
    self.texture = texture
    self.quad = quad
end

return Image