local Image = require('src/textures/Image')
local State = require("src/states/State")
local ButtonSet = require('src/objects/ButtonSet')
local CursorButton = require('src/objects/CursorButton')
local UITextureIndex = require("src/textures/UITextureIndex")

local MenuState = Class{__includes = State}

function MenuState:init()
    State.init(self)
end

function MenuState:enter(params)

    self.level = params.level

    -- self.xOffset = 0
    -- self.yOffset = 0
    -- self.image = Image.createFromName("pause")
    self.rectWidth = 200
    self.rectHeight = 120

    self.buttonSet = ButtonSet({
        CursorButton(
            UITextureIndex.continueHover,
            UITextureIndex.continue,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.continue.width) / 2),
            120,
            true,
            function()
                GlobalState.stateMachine:remove()
            end
        ),
        CursorButton(
            UITextureIndex.quitHover,
            UITextureIndex.quit,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.quit.width) / 2),
            160,
            true,
            function()
                GlobalState.stateMachine:clobber("titleScreen", {})
            end
        )
    })

    self:addRenderable(
        self.buttonSet
    )

end

function MenuState:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangleScaled(
        "fill",
        math.floor((Constants.VIRTUAL_WIDTH - self.rectWidth) / 2),
        math.floor((Constants.VIRTUAL_HEIGHT - self.rectHeight) / 2),
        self.rectWidth,
        self.rectHeight
    )
    love.graphics.setColor(255, 255, 255, 255)
    State.render(self)
end

function MenuState:inputHandleKeyPress(key)
    self.buttonSet:inputHandleKeyPress(key)
end

return MenuState