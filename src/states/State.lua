local State = Class{}

function State:init()
    self.renderables = {}
    self.updateables = {}
end

function State:enter(params)

end

function State:exit()

end

function State:updateCallback()
    return
end

function State:update(dt)
    for _, updatable in pairs(self.updateables) do
        updatable:update(dt)
    end
    self:updateCallback()
end

function State:render()
    for _, renderable in pairs(self.renderables) do
        renderable:render()
    end
end

function State:addRenderable(renderable)
    if renderable.render and type(renderable.render) == "function" then
        table.insert(self.renderables, renderable)
    else
        logger("e", "Tried to register: " .. tostring(renderable) .. "for rendering, but it was not renderable")
    end
end

function State:addUpdateable(updateable)
    if updateable.update and type(updateable.update) == "function" then
        table.insert(self.updateables, updateable)
    else
        logger("e", "Tried to register: " .. tostring(updateable) .. "for updating, but it was not updateable")
    end
end

function State:inputHandleKeyPress(key)
    return
end

return State
