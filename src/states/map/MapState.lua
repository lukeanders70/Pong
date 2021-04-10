local State = require("src/states/State")
local World = require('src/world/World')

local MapState = Class{__includes = State}

function MapState:init()
    State.init(self)
end

function MapState:enter(params)
    local worldName = getOrElse(params, "worldName", "steaming-desert", "MapState world name not found in params")
    local playerLocationId = getOrElse(params, "levelId", 1)
    self.world = World(worldName, playerLocationId)
    self:addRenderable(self.world)
end

function MapState:inputHandleKeyPress(key)
    self.world:inputHandleKeyPress(key)
end

return MapState
