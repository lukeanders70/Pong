-- love setups
love.graphics.setDefaultFilter('nearest', 'nearest')
love.window.setTitle('Pong II')

-- Gobals
Constants = require('src/Constants')
GlobalState = {}
Timer = require('lib/knife.timer')
Class = require('lib/class')

-- set Global Helper Functions
require('src/GlobalHelpers')
require('src/LoveExtensions')

-- dependencies
local StateMachine = require('src/states/StateMachine')
local StatePoints = require('src/StatePoints')
local Camera = require('src/Camera')
local SaveData = require('src/SaveData')

-- States
local PlayState = require('src/states/play/PlayState')
local MapState = require('src/states/map/MapState')
local TitleScreenState = require('src/states/titleScreen/TitleScreenState')
local LevelCompleteState = require('src/states/levelComplete/LevelCompleteState')

function love.load(args)
	-- Basic Setup
	math.randomseed(os.time())
	
	love.window.setMode( 1024, 574, {fullscreen = false} )

	setDimensions(love.graphics.getWidth(), love.graphics.getHeight())

	--setup fonts
	-- fontWhite = love.graphics.newImageFont("graphics/font-small.png"," ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/")
	-- fontBlack = love.graphics.newImageFont("graphics/font-small-black.png"," ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/")
    -- love.graphics.setFont(fontBlack)
    
	-- Setup GlobalState
    GlobalState.camera = Camera()
	GlobalState.stateMachine = StateMachine {
		['play'] = function() return PlayState() end,
		['map'] = function() return  MapState() end,
		['titleScreen'] = function() return TitleScreenState() end,
		['levelComplete'] = function() return LevelCompleteState() end
	}
	GlobalState.saveData = SaveData(true)

	love.mouse.mousePositionGameX = 0
	love.mouse.mousePositionGameY = 0

	StatePoints.titleScreen()
end

function love.resize(w, h)
	setDimensions(w, h)
end

function setDimensions(w, h)
	Constants.WINDOW_WIDTH = w
	Constants.WINDOW_HIGHT = h
	Constants.SCALE_MULTIPLIER = Constants.WINDOW_WIDTH / Constants.VIRTUAL_WIDTH
end

function love.keypressed(key)
	GlobalState.stateMachine:handleKeyEvent(key)
end

function love.mousepressed( x, y, button, istouch, presses )

end

function love.update(dt)
	Timer.update(dt)

	love.mouse.lastMousePositionGameX = love.mouse.mousePositionGameX
	love.mouse.lastMousePositionGameY = love.mouse.mousePositionGameY
	love.mouse.mousePositionGameX, love.mouse.mousePositionGameY = love.mouse.getPosition()
	
	-- stateMachine will always have one active state. This is the one we will update
	GlobalState.stateMachine:update(dt)
end

function love.draw()
	-- stateMachine will draw all open states
	GlobalState.stateMachine:render()

end