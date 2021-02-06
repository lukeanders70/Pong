local StatePoints = {}

function StatePoints.levelOne() 
    GlobalState.stateMachine:add('play', {levelId = "1", worldName = "steaming-desert"})
end

function StatePoints.levelFour() 
    GlobalState.stateMachine:add('play', {levelId = "4", worldName = "steaming-desert"})
end

function StatePoints.worldOne() 
    GlobalState.stateMachine:add('map', {worldName = "steaming-desert"})
end

function StatePoints.titleScreen()
    GlobalState.stateMachine:add('titleScreen', {})
end

return StatePoints