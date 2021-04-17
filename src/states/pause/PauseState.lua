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

    self.xOffset = 0
    self.yOffset = 0
    self.image = Image.createFromName("pause")

    self.buttonSet = ButtonSet({
        CursorButton(
            UITextureIndex.continueHover,
            UITextureIndex.continue,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.continue.width) / 2),
            168,
            true,
            function()
                GlobalState.stateMachine:remove()
            end
        ),
        CursorButton(
            UITextureIndex.quitHover,
            UITextureIndex.quit,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.quit.width) / 2),
            200,
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

function PauseState:render()
    love.graphics.drawScaled(self.image.texture, self.image.quad, self.xOffset, self.yOffset, 0, self.scaleX, self.scaleY)
    State.render(self)
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