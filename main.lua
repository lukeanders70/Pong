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

-- dependencies
local StateMachine = require('src/states/StateMachine')
local push = require('lib/push')
local StatePoints = require('src/StatePoints')
local Camera = require('src/Camera')
-- States
local PlayState = require('src/states/play/PlayState')


function love.load(args)
	-- Basic Setup
    math.randomseed(os.time())
	push:setupScreen(
		Constants.VIRTUAL_WIDTH,
		Constants.VIRTUAL_HEIGHT,
		Constants.WINDOW_WIDTH,
		Constants.WINDOW_HIGHT,
		{
			vsync = true,
			fullscreen = true,
			resizable = true,
			canvas = true
		}
	)

	--setup fonts
	-- fontWhite = love.graphics.newImageFont("graphics/font-small.png"," ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/")
	-- fontBlack = love.graphics.newImageFont("graphics/font-small-black.png"," ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/")
    -- love.graphics.setFont(fontBlack)
    
	push:setBorderColor({0, 0, 0, 255})

	-- Setup GlobalState
    GlobalState.camera = Camera()
	GlobalState.stateMachine = StateMachine {
		['play'] = function() return PlayState() end
	}

	love.mouse.mousePositionGameX = 0
	love.mouse.mousePositionGameY = 0

	StatePoints.levelOne()
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)

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
	push:start()

	-- stateMachine will draw all open states
	GlobalState.stateMachine:render()

	push:finish()
end