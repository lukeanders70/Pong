local Image = require('src/textures/Image')
local State = require("src/states/State")
local ButtonSet = require('src/objects/ButtonSet')
local CursorButton = require('src/objects/CursorButton')
local UITextureIndex = require("src/textures/UITextureIndex")
local Renderable = require('src/objects/Renderable')

local MenuState = Class{__includes = State}

function MenuState:init()
    State.init(self)
end

function MenuState:enter(params)

    self.level = params.level

    self.rectWidth = 200
    self.rectHeight = 120

    self.titleImage = Image.createFromName("menu")

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
        Renderable.fromImage(self.titleImage, 0, 0)
    )

    self:addRenderable(
        self.buttonSet
    )

end

function MenuState:inputHandleKeyPress(key)
    self.buttonSet:inputHandleKeyPress(key)
end

return MenuState