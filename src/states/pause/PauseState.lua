local Image = require('src/textures/Image')
local State = require("src/states/State")
local ButtonSet = require('src/objects/ButtonSet')
local CursorButton = require('src/objects/CursorButton')
local UITextureIndex = require("src/textures/UITextureIndex")

local PauseState = Class{__includes = State}

function PauseState:init()
    State.init(self)
end

function PauseState:enter(params)

    --self.image = Image.createFromName("pause")
    self.level = params.level

    self.buttonSet = ButtonSet({
        CursorButton(
            UITextureIndex.continueHover,
            UITextureIndex.continue,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.continue.width) / 2),
            190,
            true,
            function()
                GlobalState.stateMachine:remove()
            end
        ),
        CursorButton(
            UITextureIndex.newGameHover,
            UITextureIndex.newGame,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.newGame.width) / 2),
            225,
            true,
            function()
                GlobalState.stateMachine:remove()
                self.level:levelFailed()
            end
        )
    })

    self:addRenderable(
        self.buttonSet
    )

end

function PauseState:inputHandleKeyPress(key)
    if self.canDismiss and (key == "return") then
        GlobalState.stateMachine:remove()
        if self.callback then
            self.callback()
        end
    end
end

function PauseState:inputHandleKeyPress(key)
    self.buttonSet:inputHandleKeyPress(key)
end

return PauseState