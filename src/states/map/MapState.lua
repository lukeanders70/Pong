local State = require("src/states/State")
local World = require('src/world/World')

local MapState = Class{__includes = State}

function MapState:init()
    State.init(self)
end

function MapState:enter(params)
    local worldName = getOrElse(params, "worldName", "steaming-desert", "MapState world name not found in params")
    self.world = World(worldName)
    self:addRenderable(self.world)
    self:addUpdateable(self.world)
end

return MapState
