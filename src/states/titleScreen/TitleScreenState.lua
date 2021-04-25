local State = require("src/states/State")
local Image = require("src/textures/Image")
local UITextureIndex = require("src/textures/UITextureIndex")
local Renderable = require('src/objects/Renderable')
local CursorButton = require('src/objects/CursorButton')
local ButtonSet = require('src/objects/ButtonSet')

local TitleScreenState = Class{__includes = State}

function TitleScreenState:init()
    State.init(self)
end

function TitleScreenState:enter()
    self.titleImage = Image.createFromName("title-screen")

    self.music = love.audio.newSource("assets/main-theme.mp3", "stream")

    self.buttonSet = ButtonSet({
        CursorButton(
            UITextureIndex.continueHover,
            UITextureIndex.continue,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.continue.width) / 2),
            170,
            not GlobalState.saveData:isEmpty(),
            function()
                GlobalState.stateMachine:swap('map', {worldName = "steaming-desert"})
            end
        ),
        CursorButton(
            UITextureIndex.newGameHover,
            UITextureIndex.newGame,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.newGame.width) / 2),
            205,
            true,
            function()
                GlobalState.saveData:clear()
                GlobalState.stateMachine:swap('map', {worldName = "steaming-desert"})
            end
        ),
        CursorButton(
            UITextureIndex.quitHover,
            UITextureIndex.quit,
            math.floor((Constants.VIRTUAL_WIDTH - UITextureIndex.quit.width) / 2),
            240,
            true,
            function()
                love.event.quit()
            end
        )
    })

    self:addRenderable(
        self.buttonSet
    )

    self.music:play()

end

function TitleScreenState:exit()
    self.music:stop()
end

function TitleScreenState:inputHandleKeyPress(key)
    self.buttonSet:inputHandleKeyPress(key)
end

function TitleScreenState:render()
    love.graphics.drawScaled(self.titleImage.texture, self.titleImage.quad, 0, 0, 0, 1, 1)
    State.render(self)
end

return TitleScreenState
