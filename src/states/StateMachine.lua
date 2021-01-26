local Class = require('lib/class')
local StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end,
		suspended = false
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = {}
	table.insert(self.current, self.empty)
end

function StateMachine:add(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	local newState = self.states[stateName]()
	newState.suspeded = false
	table.insert(self.current, newState)
	newState:enter(enterParams)

	CURRENT_STATE = newState
end

function StateMachine:addState(state)
	state.suspeded = false
	table.insert(self.current, state)

	CURRENT_STATE = state
end

-- remove every other state and start a new one on a blank stack
function StateMachine:clobber(stateName, enterParams)
	while #self.current > 1 do
		self:remove()
	end
	self:add(stateName, enterParams)
end

-- remove every other state and start a new one on a blank stack (accepts an actual, already started state)
function StateMachine:clobberState(state)
	while #self.current > 1 do
		self:remove()
	end
	self:addState(state)
end

--removes the top of the stack
function StateMachine:remove()
	table.remove(self.current):exit()

	CURRENT_STATE = self.current[#self.current]
	CURRENT_STATE.suspeded = false
end

function StateMachine:update(dt)
	self.current[#self.current]:update(dt)
end

function StateMachine:handleMouseEvent(mousePress)
	self.current[#self.current].inputHandler:inputHandleMousePress(mousePress)
end

function StateMachine:handleKeyEvent(key)
	if #self.current > 0 then
		self.current[#self.current]:inputHandleKeyPress(key)
	end
end

function StateMachine:render()
	for i = 1, #self.current do
		if not self.current[i].suspeded then
			self.current[i]:render()
		end
    end
end

function StateMachine:swap(stateName, enterParams)
	self:remove()
	self:add(stateName, enterParams)
end

function StateMachine:addAndSuspend(stateName, enterParams)
    self.current[#self.current].suspeded = true
	self:add(stateName, enterParams)
end

return StateMachine
